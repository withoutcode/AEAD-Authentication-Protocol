set DLIB DBDBDB                            ;# Define the directories of library
set DP DPDPDP                                 ;# Define the directories of project
set TOP TOPTOPTOP                                          ;# Top-level module name 
set myFiles ${DP}/src/FILEFILEFILE				; # list of all HDL files in the design
set NScan 0                                                   ;# The number of scan chain
set myClk clk                                                 ;# The name of your clock
set virtual 1                                                 ;# 1 if virtual clock, 0 if real clock
set libFile "tsmc90.db"									  ;# Define the target_libraries
set myPeriod_ns 5                                             ;# desire clock period (in ns) (sets speed goal)

set search_path [concat $search_path ${DP}/src ${DLIB}]       ;# Define the search_path
set target_library ${DLIB}/$libFile                           ;# Define the target_libraries
set link_library [concat "*" $target_library]                 ;# Define the link_libraries

set runname syn                                               ;# Name appended to output files
set dft_runname syn_dft                                       ;# Name appended to output files for scan
set exit_dc 1                                                 ;# 1 to exit DC after running, 0 to keep DC running
set verbose 0                                                 ;# 1 Write reports to screen, 0 do not write reports to screen

set myClkLatency_ns 0                                         ;# clock network latency
set myInDelay_ns 0                                            ;# delay from clock to inputs valid
set myOutDelay_ns 0                                           ;# delay from clock to output valid
set myMaxFanout  1                                            ;# max fanout load for input pins
set myFanoutLoad 8                                            ;# fanout load
set myOutputLoad 0.1                                          ;# output pin loading
set myInputBuf INVX1                                          ;# name of cell driving the inputs
set myLoadLibrary [file rootname $target_library]             ;# name of library the cell comes from
set myLoadPin A                                               ;# name of pin that the outputs drive

set optimizeArea 0                                            ;# 1 for area, 0 for speed 
set useUltra 0                                                ;# 1 for compile_ultra, 0 for compile
                                                               # mapEffort, useUngroup are for 
                                                               # non-ultra compile...   
set useUngroup 1                                              ;# 0 if no flatten, 1 if flatten
set fileFormat VHDL                                        ;# Verilog or VHDL






remove_design -all                                            ;# remove any other designs from design compiler's memory
define_design_lib WORK -path ${DP}/work


analyze -library WORK -format $fileFormat $myFiles            ;# Analyzer  source files
elaborate $TOP -architecture structural -library DEFAULT     ;# Elaborate source files
current_design $TOP                                           ;# Set design to 'highest' module level

link                                                          ;# Link to standard cell libraries
uniquify                                                      ;# Uniquify


if { $useUltra == 1 } {                                       ;# Now compile the design with given mapping effort 
    compile_ultra  -scan                                      ;# and do a second compile with incremental mapping
} else {                                                      ;# or use the compile_ultra meta-command
if { $useUngroup == 1 } {
    compile -ungroup_all -map_effort medium -scan
} else {
    compile -map_effort medium -exact_map -scan
}
}



check_design
report_constraint -all_violators

set filebase [format "%s%s" [format "%s%s" $TOP "_"] $dft_runname]
set filename [format "%s%s%s" ${DP}/src/ $filebase ".vhd"]
redirect change_names { change_names -rules verilog -hierarchy -verbose }
write -format verilog -hierarchy -output $filename          ;# Generate verilog code for synthesized module

set filename [format "%s%s%s" ${DP}/src/ $filebase ".sdf"]
write_sdf -version 1.0 $filename                            ;# Generate SDF for synthesized module

set filename [format "%s%s%s" ${DP}/src/ $filebase ".sdc"]
write_sdc $filename                                         ;# Generate SDC  for synthesized module

set filename [format "%s%s%s" ${DP}/src/ $filebase ".ddc"]
write -hierarchy -format ddc -output $filename              ;# Generate DDC  for synthesized module




if { $verbose == 1 } {                                      ;# Generate reports for user to view 
report_design
report_hierarchy
report_timing -path full -delay max -nworst 3 -significant_digits 2 -sort_by group
report_timing -path full -delay min -nworst 3 -significant_digits 2 -sort_by group
report_area
report_cell 
report_net 
report_port -v
report_power -analysis_effort low
}

# Design and Hierarchy reports
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".design"]
redirect $filename { report_design }
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".design"]
redirect -append $filename { report_hierarchy }

# Timing reports
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".timing"]
redirect $filename { report_timing -path full -delay max -nworst 5 -significant_digits 2 -sort_by group 
}
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".timing"]
redirect -append $filename { report_timing -path full -delay min -nworst 5 -significant_digits 2 -sort_by group }

# Report_cell and report_area
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".area"]
redirect $filename { report_area }
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".area"]
redirect -append $filename { report_cell }

# Report port
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".ports"]
redirect $filename { report_port -v}

#report net
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".net"]
redirect $filename { report_net }

# report power
set filename [format "%s%s%s" ${DP}/reports/ $filebase ".pow"]
redirect $filename { report_power -analysis_effort low }


# report dft_drc
set filename [format "%s%s%s"  ${DP}/reports/ $filebase ".violators"]
redirect $filename { report_constraint -all_violators }


# report dft_drc
set filename [format "%s%s%s"  ${DP}/reports/ $filebase ".dft_drc"]
redirect $filename { dft_drc -verbose -coverage_estimate }

# report scan path
set filename [format "%s%s%s"  ${DP}/reports/ $filebase ".scan_path"]
redirect $filename { report_scan_path -view existing -chain all }

# report cells
set filename [format "%s%s%s"  ${DP}/reports/ $filebase ".cell"]
redirect $filename { report_cell }

# Write out protocol
set filename [format "%s%s%s"  ${DP}/src/ $filebase ".spf"]
write_test_protocol -output $filename


if { $exit_dc == 1} {
exit
}       


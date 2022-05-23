
#Arguments: Absolute address of folder that contains "verilog files" and "tsmc90.db"
#Output: power of "verilog files" in "result.txt"
import sys
import glob
import os
import re
def extract_power_result(ver_file):
	file_loc = str(ver_file[:len(ver_file)-4])
	power_file = glob.glob(file_loc+"/reports/*.pow")
	f = open(power_file[0],"r")
	power_report = f.read()
	f.close()
	search = re.findall("Total Dynamic Power \s*=\s+(\d*.\d*\s+\S+)",power_report)
	f = open("pow_result.txt","a")
	f.write(str(file_loc[file_loc.rfind("/")+1:])+" "+str(search[0])+"\n")
	f.close()
def extract_area_result(ver_file):
	file_loc = str(ver_file[:len(ver_file)-4])
	power_file = glob.glob(file_loc+"/reports/*.area")
	f = open(power_file[0],"r")
	power_report = f.read()
	f.close()
	search = re.findall("Total cell area:\s*(\d*.\d*\s+\S+)",power_report)
	f = open("area_result.txt","a")
	f.write(str(file_loc[file_loc.rfind("/")+1:])+" "+str(search[0])+"\n")
	f.close()

def generate_compile_tcl(ver_file):
	f = open("compile.tcl","r")
	tcl = f.read()
	f.close()
	file_loc = str(ver_file[:len(ver_file)-4])
	tcl = tcl.replace("DBDBDB",(file_loc+"/db"))
	tcl = tcl.replace("DPDPDP",(file_loc))
	module_name = file_loc[file_loc.rfind("/")+1:]
	tcl = tcl.replace("TOPTOPTOP",(module_name))
	tcl = tcl.replace("FILEFILEFILE",(module_name+".vhd"))
	h = open(ver_file[:len(ver_file)-4]+".tcl","w")
	h.write(tcl)
	h.close()
def main():
	files_path = sys.argv[1]
	files = glob.glob(files_path+"/*.vhd")
	for i in files:
		os.system("mkdir "+str(i)[:len(i)-4])
		os.system("mkdir "+str(i)[:len(i)-4]+"/src")
		os.system("mv "+str(i)+" "+str(i)[:len(i)-4]+"/src/")
		os.system("mkdir "+str(i)[:len(i)-4]+"/sim")
		os.system("mkdir "+str(i)[:len(i)-4]+"/db")
		os.system("cp "+files_path+"/tsmc90.db "+str(i)[:len(i)-4]+"/db/")
		os.system("mkdir "+str(i)[:len(i)-4]+"/work")
		os.system("mkdir "+str(i)[:len(i)-4]+"/reports")
		generate_compile_tcl(i)
		#kk = input("checkTCL?!!!")
		os.system("dc_shell -f "+i[:len(i)-4]+".tcl | tee "+str(i)+".log")
		os.system("rm "+i[:len(i)-4]+".tcl")
		extract_area_result(i)
		extract_power_result(i)

if __name__=="__main__":
	main()

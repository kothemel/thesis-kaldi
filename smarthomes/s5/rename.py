import os
os.chdir("waves_smarthomes")
for filename in os.listdir("."):
	done=0
	count=0
	temp=filename[12:]
	print temp
	for i in range (3):
		
		if temp[i].isdigit():
			count=count+1
		else:
			break

	if count==1:
		os.rename(filename, filename[0:12]+'00'+temp)
	elif count==2:
		os.rename(filename, filename[0:12]+'0'+temp)

import csv as csv
import glob
from subprocess import call,Popen
import math

df = open("labels.txt",'w+')
part_i = csv.reader(open("test.csv","r"))
data = []

for row in part_i:
	data.append(row)

for i in range (0,len(data)-1):
	data[i][1]= data[i+1][0]
i=i+1
data[i][1]= str(float(data[i][0])+float(data[i][1]))
#print data

for i in range (0,len(data)):
	v1 = float(data[i][0])
	v2 = float(data[i][1])

	times = math.floor(v2*100)-math.floor(v1*100)
	#print data[i][2] + " printed "+str(times)+" times"
	
	for j in range (0,int(times)):
		df.write(data[i][2])
		df.write('\n')

df.close()




x=open("origlabels.txt",'r+')
y=open("labels.txt",'r+')
count=0 
for t in range (0,149996):
    line1 = x.readline()
    line2 = y.readline()
    
    if line1==line2:
    	count=count+1
print count
print "Error: "+str(1-float(count)/float(149996))


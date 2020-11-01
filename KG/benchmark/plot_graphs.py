#!/usr/bin/python3
#params
cu = 10
inst = 160#144 #160 #161 + 1 #143+1
oper = 16

import matplotlib.pyplot as plt
import sys
import math
import statistics

workingdir = sys.argv[1]
if len(sys.argv) >= 3:
	stopat = sys.argv[2]	#in miliseconds
else:
	stopat = ''


count_instruction = [0 for i in range(inst)]
count_operation = [0 for i in range(oper)]
cycles_instruction = [0 for i in range(inst)]
cycles_operation = [0 for i in range(oper)]
generated_pixels = []
drawn_pixels = []
prepared_texels = []	#w sumie to teraz powinno być to samo co generated pixels
fb_utilization = []
cu_utilization = [[] for i in range(cu)]
cycles_cu_waiting_for_pixel_poll = [[] for i in range(cu)]
cycles_cu_waiting_for_texel = [[] for i in range(cu)]

#read the data
cyclesinwindow = 25000
ts = open(sys.argv[1]+"time_series","r")
line = ts.readline()
timesample = 0
while (not(line == '' or (stopat != '' and timesample > 2*int(stopat)))):
	splitted = line.split(" ")
	generated_pixels += [int(splitted[2])]
	drawn_pixels += [int(splitted[3])]
	prepared_texels += [int(splitted[4])]	
	fb_utilization += [int(splitted[5])/cyclesinwindow]
	for i in range(cu):
		line = ts.readline()
		cusplit = line.split(" ")

		cu_utilization[i] += [(int(cusplit[1])-int(cusplit[2])-int(cusplit[3]))/cyclesinwindow]
		cycles_cu_waiting_for_pixel_poll[i] += [int(cusplit[2])]
		cycles_cu_waiting_for_texel[i] += [int(cusplit[3])]
		offset=4
		for j in range(offset,offset+inst):
			cycles_instruction[j-offset] += int(cusplit[j])	
		offset += inst
		for j in range(offset,offset+oper):
			cycles_operation[j-offset] += int(cusplit[j])	
		offset += oper
		for j in range(offset,offset+inst):
			count_instruction[j-offset] += int(cusplit[j])
		offset += inst
		for j in range(offset,offset+oper):
			count_operation[j-offset] += int(cusplit[j])
	timesample += 1
	line = ts.readline()
	
ts.close()

#too much samples group them!
group=2 #1 sample will be 10ms = 500000cycles
grouped_cuu = []
grouped_gp = [sum(generated_pixels[i:i+group]) for i in range(0, len(generated_pixels), group)]   
grouped_dp = [sum(drawn_pixels[i:i+group]) for i in range(0, len(drawn_pixels), group)]   
grouped_pt = [sum(prepared_texels[i:i+group]) for i in range(0, len(prepared_texels), group)]
grouped_fbu = [statistics.mean(fb_utilization[i:i+group]) for i in range(0, len(fb_utilization), group)]
for j in range(cu):
	grouped_cuu.insert(j,[statistics.mean(cu_utilization[j][i:i+group]) for i in range(0, len(cu_utilization[j]), group)])
timeline = [int(i/2) for i in range(0,timesample, group)]

#plot
plt.bar(range(inst),[x/100000000 for x in count_instruction], color = 'blue')
plt.xlabel('instrukcja')
plt.ylabel('liczba wywołań $10^6$')
plt.title('Wywołania instrukcji')
plt.savefig(workingdir+"count_instructions.png",dpi=1000) 
plt.close()
plt.bar(range(inst),[x/1000000 for x in cycles_instruction], color = 'green')
plt.xlabel('instrukcja')
plt.ylabel('liczba cykli zegarowych  $10^6$')
plt.title('Cykle spędzone na obsłudze instrukcji')
plt.savefig(workingdir+"cycles_instructions.png",dpi=1000)
plt.close()
plt.bar(range(oper),[x/100000000 for x in count_operation], color = 'blue')
plt.xlabel('operacja')
plt.ylabel('liczba wywołań $10^6$')
plt.title('Wywołania operacji')
plt.savefig(workingdir+"count_operations.png",dpi=1000)
plt.close()
plt.bar(range(oper),[x/1000000 for x in cycles_operation], color = 'green')
plt.xlabel('instrukcja')
plt.ylabel('liczba cykli zegarowych $10^6$')
plt.title('Cykle spędzone na obsłudze operacji')
plt.savefig(workingdir+"cycles_operations.png",dpi=1000)
plt.close()


plt.plot(timeline,grouped_gp, color = 'green',label='wygenerowane piksele')
plt.plot(timeline,grouped_dp, color = 'blue',label='narysowane piksele')
plt.plot(timeline,grouped_pt, color = 'red',label='pobrane teksele')
plt.xlabel('czas symulacji [ms]')
plt.ylabel('ilość przetworzonych pikseli na jedną milisekundę')
plt.title('Przetwarzanie pikseli')
plt.ylim(bottom=0)
plt.xlim(left=0)
plt.legend(loc='upper right', shadow=True)
plt.savefig(workingdir+"pixels.png",dpi=1000)
plt.close()


#colors=['red','green','blue','orange','pink','yellow','gray','lime','red','green']
plt.plot(timeline,grouped_fbu, color = 'red',label='FB')
for i in range(cu):
	if i == 0:
		plt.plot(timeline,grouped_cuu[i], color = 'orange',label='CU 1..'+str(cu))
	else:
		plt.plot(timeline,grouped_cuu[i], color = 'orange')
plt.xlabel('czas symulacji [ms]')
plt.ylabel('Wykorzystanie modułu')
plt.title('Wykorzystanie CU i FB')
plt.ylim(bottom=0)
plt.xlim(left=0)
plt.legend(loc='lower left', shadow=True)
plt.savefig(workingdir+"utilization.png",dpi=1000)
plt.close()

stat = open(workingdir+"stat.txt","w")
stat.write("sum_cycles:"+str(sum(cycles_instruction))+"\n")
stat.write("sum_executed_instrucitons:"+str(sum(count_operation))+"\n")
for i in range(cu):
	stat.write("CU"+str(i+1)+" cycles_cu_waiting_for_pixel_poll="+str(sum(cycles_cu_waiting_for_pixel_poll[i]))+"\n")
	stat.write("CU"+str(i+1)+" cycles_cu_waiting_for_texel="+str(sum(cycles_cu_waiting_for_texel[i]))+"\n")
stat.close()

#!/usr/bin/python

import sys

def get_performance(input_file, out_dir, pattern, id):
	import numpy as np
	txt_arr = []
	with open(input_file, 'r') as handle:
		for line in handle:
			txt_arr.append(line)

	# get some
	tmp_idx_start = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nstart ' + pattern + '\\n\n') != -1][0]
	tmp_idx_end = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nend ' + pattern + '\\n\n') != -1][0]
	#
	n_core = [] 
	mem = []
	mflops = []
	dur = []
	SP = []
	#
	for txt in txt_arr[tmp_idx_start + 1:tmp_idx_end]:
		tmp_txt = txt.split('\n')[0].split('\t')
		# append
		n_core.append(float(tmp_txt[0]))
		mem.append(float(tmp_txt[1]))
		mflops.append(float(tmp_txt[2]))
		dur.append(float(tmp_txt[3]))

	#
	arr = np.zeros((len(mem),7))
	arr[:,0] = n_core
	arr[:,1] = mem
	arr[:,2] = mflops
	arr[:,3] = dur

	# calculate S(p)
	SP = dur

	# find parallel fraction f
	if len(list(set(arr[:,0]))) != 1:
		# find idx
		idx_0 = np.where(arr[:,0] == list(set(arr[:,0]))[0])[0][0]
		# init f
		f = []
		f.append(1.0)
		for nn in range(1,len(set(arr[:,0]))):
			idx_1 = np.where(arr[:,0] == list(set(arr[:,0]))[nn])[0][0]
			# 
			f.append((1 - arr[idx_1,3] / arr[idx_0,3]) / (1 - (1/arr[idx_1,0])))

		#
		f_tmp = []
		for jj in range(len(f)):
			for ii in range(int(len(arr[:,0]) / len(set(arr[:,0])))):
				f_tmp.append(f[jj])
		#
		arr[:,5] = f_tmp
		arr[:,4] = arr[0,3] / arr[:,3]
		arr[:,6] = arr[:,0] / arr[:,3]

	else:
		arr[:,4] = -1
		arr[:,5] = -1
		arr[:,6] = arr[:,0] / arr[:,3]

	# print that shi
	with open(out_dir + pattern + '.txt', "w") as text_file:
		print('ncore,mem,mflops,dur,SP,f,ncore_dur', file=text_file)
		for ii in range(len(mem)): 
			print(arr[ii,0],',',arr[ii,1],',',arr[ii,2],',',arr[ii,3],',',arr[ii,4],',',arr[ii,5],',',arr[ii,6], file=text_file)

	text_file.close
	print('File created: ' + pattern + '.txt')

	for jj in set(n_core):
		tmp_idx = arr[:,0] == jj
		with open(out_dir + pattern + '_ncore_' + str(int(jj)) + '.txt', "w") as text_file:
			print('ncore,mem,mflops,dur,SP,f,ncore_dur', file=text_file)
			for ii in np.where(arr[:,0] == jj)[0]: 
				print(arr[ii,0],',',arr[ii,1],',',arr[ii,2],',',arr[ii,3],',',arr[ii,4],',',arr[ii,5],',',arr[ii,6], file=text_file)
			#
			text_file.close
			print(pattern + '_ncore_' + str(int(jj)) + '.txt')

if __name__ == "__main__":
	get_performance(input_file=sys.argv[1], out_dir =sys.argv[2], pattern=sys.argv[3], id=sys.argv[4])


#!/usr/bin/python

import sys

def get_performance(input_file, out_dir, pattern, id):
	txt_arr = []
	with open(input_file, 'r') as handle:
		for line in handle:
			txt_arr.append(line)

	# get NMK
	tmp_idx = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('arr=(') != -1]
	tmp_str = txt_arr[tmp_idx[0]][5:-2].split(' ')
	mnk = [float(tmp_str[ii]) for ii in range(len(tmp_str))]    


	tmp_idx_start = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nstart ' + pattern + '\\n\n') != -1][0]
	tmp_idx_end = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nend ' + pattern + '\\n\n') != -1][0]
	#
	mem = []
	mflops = []
	mnull = []

	for txt in txt_arr[tmp_idx_start + 1:tmp_idx_end]:
		tmp_txt = tmp_txt = txt.split('#')[0].split(' ')
		tmp_num = [float(tmp_txt[ii]) for ii in range(len(tmp_txt)) if len(tmp_txt[ii]) != 0]
		# append 
		mem.append(tmp_num[0])
		mflops.append(tmp_num[1])
		mnull.append(tmp_num[2])

	# print that shi
	with open(out_dir + pattern + '_' + id + '.txt', "w") as text_file:
		print('mnk,mem,mflops,nul', file=text_file)
		for ii in range(len(mnk)): 
			print(mnk[ii],',',mem[ii],',', mflops[ii],',',mnull[ii], file=text_file)
	
	text_file.close
	print('File created: ' + pattern + '.txt')

if __name__ == "__main__":
    get_performance(input_file=sys.argv[1], out_dir =sys.argv[2], pattern=sys.argv[3], id=sys.argv[4])

#!/usr/bin/python

import sys

def get_performance(input_file, out_dir, pattern):
    import numpy as np
    txt_arr = []
    with open(input_file, 'r') as handle:
        for line in handle:
            txt_arr.append(line)

    # get NMK
    tmp_idx = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('arr=(') != -1]
    tmp_str = txt_arr[tmp_idx[0]][5:-2].split(' ')
    mnk = [float(tmp_str[ii]) for ii in range(len(tmp_str))]

    # get ...
    tmp_idx_start = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nstart ' + pattern + '\\n\n') != -1][0]
    tmp_idx_end = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nend ' + pattern + '\\n\n') != -1][0]

    #
    algo = []
    mem = []
    flops = []

    for txt in txt_arr[tmp_idx_start + 1:tmp_idx_end]:
        tmp_txt = txt.split('#')[0].split(' ')
        tmp_num = [float(tmp_txt[ii]) for ii in range(len(tmp_txt)) if len(tmp_txt[ii]) != 0]
        tmp_txt_algo = txt.split('#')[1].split('\n')[0].split(' ')
        algo.append([tmp_txt_algo[ii] for ii in range(len(tmp_txt_algo)) if len(tmp_txt_algo[ii]) != 0][0])

        mem.append(tmp_num[0])
        flops.append(tmp_num[1])

    # 
    n_algo = int(len(mem) / len(set(mem)))
    arr = np.zeros((len(mem),4))

    arr[:,0] = mem
    arr[:,1] = flops
    # mnk
    set_mnk = list(set(mnk))
    set_mem = list(set(mem))
    set_algo = list(set(algo))
    set_algo = sorted(set_algo)
    set_algo = set_algo[-1:] + set_algo[:-1]

    for k in range(len(set_mnk)):
        idx = np.where(arr[:,0] == set_mem[k])[0]
        arr[idx,2] = set_mnk[k]

    # find speed up
    for k in range(len(set_mnk)):
        idx = np.where(arr[:,0] == set_mem[k])[0]
        arr[idx,3] = arr[idx,1][0] / arr[idx,1]

    # print
    for k in range(len(set_mnk)):
        idx = np.where(arr[:,0] == set_mem[k])[0]
        # print that shi
        with open(out_dir + pattern + '_mnk_' +str(int(set_mnk[k])) +'.txt', "w") as text_file:
            print('mem,mflops,mnk,speed', file=text_file)
            for ii in idx: 
                print(arr[ii,0],',',arr[ii,1],',',arr[ii,2],',',arr[ii,3], file=text_file)
            #
            text_file.close

    # print
    for k in range(len(set_algo)):
        idx = np.where(np.array(algo) == set_algo[k])[0]
        # print that shi
        with open(out_dir + pattern + '_' + set_algo[k].split('_')[1] + '.txt', "w") as text_file:
            print('mem,mflops,mnk,speed', file=text_file)
            for ii in idx: 
                print(arr[ii,0],',',arr[ii,1],',',arr[ii,2],',',arr[ii,3], file=text_file)
            #
            text_file.close

    # table

    with open(out_dir + pattern + '_speedup.tex', "w") as text_file:
        for k in range(len(set_algo)):
            idx = np.where(np.array(algo) == set_algo[k])[0]
            print('\\texttt{' + set_algo[k].split('_')[1] + '()}&%.4f \\\\' %(np.mean(arr[idx,3])), file=text_file)
        #
        text_file.close

    print('Done')

if __name__ == "__main__":
    get_performance(input_file=sys.argv[1], out_dir =sys.argv[2], pattern=sys.argv[3])

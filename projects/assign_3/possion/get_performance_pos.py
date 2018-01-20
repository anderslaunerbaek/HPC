#!/usr/bin/python

import sys

def get_performance(input_file, out_dir, pattern):
    import numpy as np
    import numpy as np
    txt_arr = []
    with open(input_file, 'r') as handle:
        for line in handle:
            txt_arr.append(line)
    # get ...
    tmp_idx_start = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nstart ' + pattern + '\\n\n') != -1][0]
    tmp_idx_end = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find('\\nend ' + pattern + '\\n\n') != -1][0]
    #
    # footprint, Gflops, bandwidth GB/s, total time, I/O time, compute time
    arr = np.zeros(((tmp_idx_end - tmp_idx_start)-1, 8))
    algo = []
    for idx, txt in enumerate(txt_arr[tmp_idx_start + 1:tmp_idx_end]):
        tmp_txt = txt.split('#')[0].split('\t')[:-1]
        arr[idx,0:6] = [float(tmp_txt[ii]) for ii in range(len(tmp_txt)) if len(tmp_txt[ii]) != 0]
        arr[idx,6] = idx + 1
        algo.append(txt.split('#')[1].split('\n')[0].strip())

    # speedup
    arr[:,7] = arr[0,5] / arr[:,5]
    with open(out_dir + pattern + '_speedup.tex', "w") as text_file:
        for k in range(len(algo)):
            print('\\texttt{' + algo[k] + '}&%.4fx \\\\' %(arr[k,7]), file=text_file)
            
        #
        text_file.close
        
    # print

    with open(out_dir + pattern + '.txt', "w") as text_file:
        print('mem,gflops,bw,tot_time,io_time,cpu_time,x,speed', file=text_file)
        for ii in range(arr.shape[0]): 
            print(arr[ii,0],',',arr[ii,1],',',arr[ii,2],',',arr[ii,3],',',arr[ii,4],',',arr[ii,5],',',arr[ii,6],',',arr[ii,7], file=text_file)
        #
        text_file.close
    print('Done')

if __name__ == "__main__":
    get_performance(input_file=sys.argv[1], out_dir =sys.argv[2], pattern=sys.argv[3])

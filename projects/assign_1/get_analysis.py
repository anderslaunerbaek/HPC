#!/usr/bin/python

import sys

def get_analysis(file, id, function, n):
    """
    file = './analysis_out/test.nat'
    id = '734753'
    function = 'matmult_nat'
    n = '3'
    """
    import numpy as np
    # init array
    ana_arr = np.zeros((int(n),6))

    for jj in range(int(n)):

        tmp_file = file + '.' + str(jj+1) + '.' + id + '.txt'
        print('Now file: ' + tmp_file)
        #
        txt_arr = []
        with open(tmp_file, 'r') as handle:
            for line in handle:
                txt_arr.append(line)

        #
        tmp_idx = [ii for ii in range(len(txt_arr)) if txt_arr[ii].find(function) != -1]

        if len(tmp_idx) != 0:
            txt_arr = txt_arr[tmp_idx[0]]
            txt_arr = txt_arr.split(' ')
            tmp_val = [float(txt_arr[ii]) for ii in range(len(txt_arr)) if len(txt_arr[ii]) != 0 and txt_arr[ii].find(function)]
            #
            ana_arr[jj][0],ana_arr[jj][1],ana_arr[jj][2] = tmp_val[0],tmp_val[1],tmp_val[2]
            ana_arr[jj][3],ana_arr[jj][4],ana_arr[jj][5] = tmp_val[3],tmp_val[4],tmp_val[5]


    # convert to percentage
    # ana_arr = np.divide(ana_arr, np.sum(ana_arr,0), out=np.zeros_like(ana_arr), where=np.sum(ana_arr,0)!=0) * 100
    # print that shi
    with open(file + '.' + id + '.txt', "w") as text_file:
        print('CPU_excl&CPU_incl&L1hits&L1miss&L2hits&L2miss', file=text_file)
        for mm in range(ana_arr.shape[0]): 
            print(ana_arr[mm][0],'&',ana_arr[mm][1],'&',
                  ana_arr[mm][2],'&',ana_arr[mm][3],'&',
                  ana_arr[mm][4],'&',ana_arr[mm][5], file=text_file)

    text_file.close
    print('File created: ' + file + '.' + id + '.txt')

if __name__ == "__main__":
    get_analysis(file=sys.argv[1], id=sys.argv[2], function=sys.argv[3], n=sys.argv[4])


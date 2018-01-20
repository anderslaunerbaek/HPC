#!/usr/bin/python

import sys

def get_vis(input_file):
	import numpy as np
	import matplotlib.pyplot as plt
	import matplotlib.cm as cm
	txt_arr = []
	with open(input_file, 'r') as handle:
		for line in handle:
			txt_arr.append(line)       
	#        
	x,y,z = [],[],[]
	#
	for txt in txt_arr:
		tmp_txt = txt.split('\n')[0].split('\t')
		# append
		x.append(float(tmp_txt[0]))
		y.append(float(tmp_txt[1]))
		z.append(float(tmp_txt[2]))
	# convert to np array    
	x = np.array(x)
	y = np.array(y)
	z = np.array(z)

	# Plot heatmap
	heatmap = z.reshape((int(np.sqrt(len(z))),int(np.sqrt(len(z)))))
	f = plt.figure()
	plt.ylabel('y')
	plt.xlabel('x')
	plt.imshow(heatmap, extent=[x.min(),x.max(),y.min(),y.max()], cmap=cm.jet)
	plt.axis([-1,1,-1,1])
	plt.xlabel('x')
	plt.ylabel('y')
	plt.xticks([-1,-0.5,0,0.5,1])
	plt.yticks([-1,-0.5,0,0.5,1])
	cb = plt.colorbar()
	f.savefig(input_file[:-4] + '.pdf', bbox_inches='tight')
	f.clf()

if __name__ == "__main__":
	import matplotlib
	matplotlib.use('Agg')
	get_vis(input_file=sys.argv[1])

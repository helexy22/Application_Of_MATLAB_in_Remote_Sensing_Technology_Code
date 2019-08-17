clear;

load fisheriris;
eva = evalclusters(meas,'kmeans','gap','klist',1:5,'B',50)

eva.B

eva = increaseB(eva,50)

eva.B
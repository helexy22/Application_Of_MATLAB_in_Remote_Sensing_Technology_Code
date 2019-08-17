clear;

load fisheriris;
eva = evalclusters(meas,'kmeans','calinski','klist',1:5)

eva = addK(eva,6:10)

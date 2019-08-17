clear;

load fisheriris;
rng('default');  % For reproducibility
eva = evalclusters(meas,'kmeans','Gap','KList',[1:6])

c = compact(eva)

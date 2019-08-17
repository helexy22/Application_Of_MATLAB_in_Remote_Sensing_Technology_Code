clear;

load fisheriris;
rng('default');  % For reproducibility
eva = evalclusters(meas,'kmeans','CalinskiHarabasz','KList',[1:6]);
figure;
plot(eva);

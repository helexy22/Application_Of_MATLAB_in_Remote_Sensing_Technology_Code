clear;

load fisheriris;
myfunc = @(X,K)(kmeans(X, K, 'emptyaction','singleton',...
    'replicate',5));
eva = evalclusters(meas,myfunc,'CalinskiHarabasz',...
    'klist',[1:6])

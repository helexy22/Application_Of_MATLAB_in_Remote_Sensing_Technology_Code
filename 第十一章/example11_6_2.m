clear;

load fisheriris;
clust = zeros(size(meas,1),6);
for i=1:6
    clust(:,i) = kmeans(meas,i,'emptyaction','singleton',...
        'replicate',5);
end
eva = evalclusters(meas,clust,'CalinskiHarabasz')

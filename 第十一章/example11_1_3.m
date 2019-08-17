clear;

%计算3-5类聚类结果
load fisheriris
d = pdist(meas);
Z = linkage(d);
c = cluster(Z,'maxclust',3:5);
crosstab(c(:,1),species)

crosstab(c(:,2),species)

crosstab(c(:,3),species)

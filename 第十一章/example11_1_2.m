clear;

%用于鱼群种类聚类
load fisheriris
Z = linkage(meas,'ward','euclidean');
c = cluster(Z,'maxclust',4);
crosstab(c,species)
firstfive = Z(1:5,:) % first 5 rows of Z
dendrogram(Z)

%对随机观测值进行聚类操作，最大分为4类
rng default;%for reproduecibility
X = rand(20000,3);
Z = linkage(X,'ward','euclidean','savememory','on');
c = cluster(Z,'maxclust',4);
scatter3(X(:,1),X(:,2),X(:,3),10,c)

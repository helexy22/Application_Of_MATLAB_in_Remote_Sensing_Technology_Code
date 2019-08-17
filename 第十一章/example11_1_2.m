clear;

%������Ⱥ�������
load fisheriris
Z = linkage(meas,'ward','euclidean');
c = cluster(Z,'maxclust',4);
crosstab(c,species)
firstfive = Z(1:5,:) % first 5 rows of Z
dendrogram(Z)

%������۲�ֵ���о������������Ϊ4��
rng default;%for reproduecibility
X = rand(20000,3);
Z = linkage(X,'ward','euclidean','savememory','on');
c = cluster(Z,'maxclust',4);
scatter3(X(:,1),X(:,2),X(:,3),10,c)

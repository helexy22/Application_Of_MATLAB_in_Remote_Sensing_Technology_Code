clear;

%指定100个虚拟样本，进行索引划分
c = cvpartition(100,'kfold',3)
%指定真实的样本，进行划分
load('fisheriris');
CVO = cvpartition(species,'k',10);

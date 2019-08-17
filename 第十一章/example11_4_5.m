clear;

MU1 = [2,2];
SIGMA1 = [2,0;0,2];
MU2 = [-2,-1];
SIGMA2 = [1,0;0,1];
rng(1);%For reproducibility

%随机生成多个高斯分布点坐标
X = [mvnrnd(MU1,SIGMA1,1000);mvnrnd(MU2,SIGMA2,1000)];
scatter(X(:,1),X(:,2),10,'.');

%拟合高斯混合模型，显示等值线图
hold on;
obj = fitgmdist(X,2);
h = ezcontour(@(x,y)pdf(obj,[x,y]),[-8,6],[-8,6]);

%利用拟合高斯混合模型，计算后验概率
P = posterior(obj,X);

%显示各个点属于高斯混合模型第一分量的后验概率
delete(h);
scatter(X(:,1),X(:,2),10,P(:,1))
hb = colorbar;
ylabel(hb,'Comonent 1 Probability')

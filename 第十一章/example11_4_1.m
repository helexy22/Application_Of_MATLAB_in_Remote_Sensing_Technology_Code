clear;

mu1 = [1 2];%设置2个中心位置和标准差
Sigma1 = [2 0; 0 0.5];
mu2 = [-3 -5];
Sigma2 = [1 0;0 1];

rng(1); % For reproducibility%生成随机点坐标
X = [mvnrnd(mu1,Sigma1,1000);mvnrnd(mu2,Sigma2,1000)];
GMModel = fitgmdist(X,2);%估计高斯混合模型

figure%显示点位及高斯混合模型结果
y = [zeros(1000,1);ones(1000,1)];
h = gscatter(X(:,1),X(:,2),y,'br','xo');
hold on
ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]),get(gca,{'XLim','YLim'}))
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
legend(h,'Model 0','Model 1')
hold off

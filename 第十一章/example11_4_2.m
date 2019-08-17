clear;

mu1 = [1 2];%设置2个中心位置和标准差
Sigma1 = [1 0; 0 1];
mu2 = [3 4];
Sigma2 = [0.5 0; 0 0.5];
rng(1); % For reproducibility%生成随机点位置
X1 = [mvnrnd(mu1,Sigma1,100);mvnrnd(mu2,Sigma2,100)];
X = [X1,X1(:,1)+X1(:,2)];%其中一组与另一组点位置相加，破坏原始的高斯模型
rng(1); % Reset seed for common start values
try
    GMModel = fitgmdist(X,2)
catch exception
    disp('There was an error fitting the Gaussian mixture model')
    error = exception.message
end

%使用正则化参数，找出混合的高斯模型成分及各自均值和标准差
rng(1); % Reset seed for common start values
GMModel = fitgmdist(X,2,'RegularizationValue',0.1)

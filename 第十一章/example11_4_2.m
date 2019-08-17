clear;

mu1 = [1 2];%����2������λ�úͱ�׼��
Sigma1 = [1 0; 0 1];
mu2 = [3 4];
Sigma2 = [0.5 0; 0 0.5];
rng(1); % For reproducibility%���������λ��
X1 = [mvnrnd(mu1,Sigma1,100);mvnrnd(mu2,Sigma2,100)];
X = [X1,X1(:,1)+X1(:,2)];%����һ������һ���λ����ӣ��ƻ�ԭʼ�ĸ�˹ģ��
rng(1); % Reset seed for common start values
try
    GMModel = fitgmdist(X,2)
catch exception
    disp('There was an error fitting the Gaussian mixture model')
    error = exception.message
end

%ʹ�����򻯲������ҳ���ϵĸ�˹ģ�ͳɷּ����Ծ�ֵ�ͱ�׼��
rng(1); % Reset seed for common start values
GMModel = fitgmdist(X,2,'RegularizationValue',0.1)

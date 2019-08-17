clear;

MU1 = [2,2];
SIGMA1 = [2,0;0,2];
MU2 = [-2,-1];
SIGMA2 = [1,0;0,1];
rng(1);%For reproducibility

%������ɶ����˹�ֲ�������
X = [mvnrnd(MU1,SIGMA1,1000);mvnrnd(MU2,SIGMA2,1000)];
scatter(X(:,1),X(:,2),10,'.');

%��ϸ�˹���ģ�ͣ���ʾ��ֵ��ͼ
hold on;
obj = fitgmdist(X,2);
h = ezcontour(@(x,y)pdf(obj,[x,y]),[-8,6],[-8,6]);

%������ϸ�˹���ģ�ͣ�����������
P = posterior(obj,X);

%��ʾ���������ڸ�˹���ģ�͵�һ�����ĺ������
delete(h);
scatter(X(:,1),X(:,2),10,P(:,1))
hb = colorbar;
ylabel(hb,'Comonent 1 Probability')

%��ʽ1 ��������������ʱ����Ҫ�����б�����Ϊ'pseudoLinear' ����'pseudoQuadratic'
clear;

load popcorn
X = popcorn(:,[1 2]);
%���õ�����ȫΪ0��ʹ��������
X(:,3) = 0; % a zero-variance column
Y = popcorn(:,3);
ppcrn = fitcdiscr(X,Y);

this = fit(temp,X,Y);

%����α���Է���
ppcrn = fitcdiscr(X,Y,'discrimType','pseudoLinear');
meanpredict = predict(ppcrn,mean(X))

%��ʽ2 ����б����ͻ�������
clear;

load fisheriris
obj = fitcdiscr(meas,species);
resuberror = resubLoss(obj)

resuberror * obj.NumObservations

R = confusionmat(obj.Y,resubPredict(obj))

obj.ClassNames

%��ʽ3 �������
clear;

load fisheriris
quadisc = fitcdiscr(meas,species,'DiscrimType','quadratic');
qerror = resubLoss(quadisc)

cvmodel = crossval(quadisc,'kfold',5);
cverror = kfoldLoss(cvmodel)

%��ʽ4 �ı���ۺ����ȼ�
clear;

%ԭʼ������
load fisheriris
obj = fitcdiscr(meas,species);
resuberror = resubLoss(obj)

R = confusionmat(obj.Y,resubPredict(obj))

obj.ClassNames

%�޸Ĵ��۾������
obj1 = obj;
obj1.Cost(2,3) = 10;
R2 = confusionmat(obj1.Y,resubPredict(obj1))

%�޸����ȼ���Ľ��
obj2 = obj;
obj2.Prior = [1 1 5];
R2 = confusionmat(obj2.Y,resubPredict(obj2))

%��ʽ5 ���б�ʽ������
%���ö���ģ�Ͳ������ֱ��������Ž��
load ovariancancer
rng(1); % For reproducibility
numPred = size(obs,2);
obs = obs(:,randsample(numPred,ceil(numPred/3)));
Mdl = fitcdiscr(obs,grp,'SaveMemory','on','FillCoeffs','off');
[err,gamma,delta,numpred] = cvshrink(Mdl,...
    'NumGamma',24,'NumDelta',24,'Verbose',1);

figure;
plot(err,numpred,'k.')
xlabel('Errorrate');
ylabel('Numberofpredictors');

%����ֲ��Ŵ�
axis([0 .1 0 1000])

%���н������С���
minerr = min(min(err))

%�ҵ���С����������Χ�Ĳ�����
% Subscripts of err producing minimal error
[p q] = find(err < minerr + 1e-4);
numel(p)

%ע�⣺������Ҫ������λ��ת��������������ֱ�Ӳ���delta(p,q)������Ҫ�Ľ��
% Convert from subscripts to linear indices
idx = sub2ind(size(delta),p,q);
[gamma(p) delta(idx)]

%���������Ĳ�����Ԥ�����������ԭʼԤ�����ٷֱ�
numpred(idx)/ceil(numPred/3)*100

%�����Ҫ���ٵ�Ԥ��������ô��Ҫ���͸��ߵĴ�����
low200 = min(min(err(numpred <= 200)));
lownum = min(min(numpred(err == low200)));
[low200 lownum]

%ע�⣺��ʱr��s������Ϊ1ʱ��delta(r,s)�ŵȼ��������ᵽ��delta(idx)
[r,s] = find((err == low200) & (numpred == lownum));
[gamma(r); delta(r,s)]

%���������������ģ�Ͳ���
Mdl.Gamma = gamma(r);
Mdl.Delta = delta(r,s);
%�Ƚ�����ͬ��Gamma��������£���ͬ��Delta���������ڽ����Ӱ��
% Create the Delta index matrix
indx = repmat(1:size(delta,2),size(delta,1),1);
figure
subplot(1,2,1)
imagesc(err);
colorbar;
colormap('jet')
title 'Classification error';
xlabel 'Delta index';
ylabel 'Gamma index';
subplot(1,2,2)
imagesc(numpred);
colorbar;
title 'Number of predictors in the model';
xlabel 'Delta index' ;
ylabel 'Gamma index' ;



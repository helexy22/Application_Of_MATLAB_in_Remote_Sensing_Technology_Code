%方式1 当处理奇异数据时，需要设置判别类型为'pseudoLinear' 或者'pseudoQuadratic'
clear;

load popcorn
X = popcorn(:,[1 2]);
%设置第三列全为0，使矩阵奇异
X(:,3) = 0; % a zero-variance column
Y = popcorn(:,3);
ppcrn = fitcdiscr(X,Y);

this = fit(temp,X,Y);

%采用伪线性方法
ppcrn = fitcdiscr(X,Y,'discrimType','pseudoLinear');
meanpredict = predict(ppcrn,mean(X))

%方式2 检查判别误差和混淆矩阵
clear;

load fisheriris
obj = fitcdiscr(meas,species);
resuberror = resubLoss(obj)

resuberror * obj.NumObservations

R = confusionmat(obj.Y,resubPredict(obj))

obj.ClassNames

%方式3 交叉检验
clear;

load fisheriris
quadisc = fitcdiscr(meas,species,'DiscrimType','quadratic');
qerror = resubLoss(quadisc)

cvmodel = crossval(quadisc,'kfold',5);
cverror = kfoldLoss(cvmodel)

%方式4 改变代价和优先级
clear;

%原始分类结果
load fisheriris
obj = fitcdiscr(meas,species);
resuberror = resubLoss(obj)

R = confusionmat(obj.Y,resubPredict(obj))

obj.ClassNames

%修改代价矩阵后结果
obj1 = obj;
obj1.Cost(2,3) = 10;
R2 = confusionmat(obj1.Y,resubPredict(obj1))

%修改优先级后的结果
obj2 = obj;
obj2.Prior = [1 1 5];
R2 = confusionmat(obj2.Y,resubPredict(obj2))

%方式5 简化判别式分类器
%设置多组模型参数，分别生成最优结果
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

%结果局部放大
axis([0 .1 0 1000])

%所有结果的最小误差
minerr = min(min(err))

%找到最小误差附近容许误差范围的参数组
% Subscripts of err producing minimal error
[p q] = find(err < minerr + 1e-4);
numel(p)

%注意：这里需要将行列位置转换到线性索引，直接采用delta(p,q)不是想要的结果
% Convert from subscripts to linear indices
idx = sub2ind(size(delta),p,q);
[gamma(p) delta(idx)]

%满足条件的参数组预测参数个数与原始预测数百分比
numpred(idx)/ceil(numPred/3)*100

%如果需要更少的预测数，那么需要忍耐更高的错误率
low200 = min(min(err(numpred <= 200)));
lownum = min(min(numpred(err == low200)));
[low200 lownum]

%注意：此时r和s个数都为1时，delta(r,s)才等价于上面提到的delta(idx)
[r,s] = find((err == low200) & (numpred == lownum));
[gamma(r); delta(r,s)]

%采用这组参数设置模型参数
Mdl.Gamma = gamma(r);
Mdl.Delta = delta(r,s);
%比较在相同的Gamma参数情况下，不同的Delta参数，对于结果的影响
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



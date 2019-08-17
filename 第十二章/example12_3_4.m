clear;

load fisheriris
X = meas;
Y = species;
rng(1); % For reproducibility
CVMdl1 = fitcnb(X,Y,...
    'ClassNames',{'setosa','versicolor','virginica'},...
    'CrossVal','on');
t = templateNaiveBayes();
CVMdl2 = fitcecoc(X,Y,'CrossVal','on','Learners',t);
classErr1 = kfoldLoss(CVMdl1,'LossFun','ClassifErr')
classErr2 = kfoldLoss(CVMdl2,'LossFun','ClassifErr')


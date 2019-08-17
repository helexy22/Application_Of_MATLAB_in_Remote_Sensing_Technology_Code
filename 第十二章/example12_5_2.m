clear;

%Load the ionosphere data set.
load ionosphere
rng(1); % For reproducibility
SVMModel = fitcsvm(X,Y,...
'Standardize',true,'KernelFunction','RBF',...
'KernelScale','auto');
CVSVMModel = crossval(SVMModel);
classLoss = kfoldLoss(CVSVMModel)


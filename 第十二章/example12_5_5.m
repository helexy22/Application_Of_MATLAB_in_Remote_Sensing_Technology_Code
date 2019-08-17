clear;

load fisheriris
X = meas;
Y = species;
Mdl = fitcecoc(X,Y)

Mdl.ClassNames

CodingMat = Mdl.CodingMatrix

%第一个两类学习器
% The first binary learner
Mdl.BinaryLearners{1}

%支持向量索引
% Support vector indices
Mdl.BinaryLearners{1}.SupportVectors

isLoss = resubLoss(Mdl)


clear;

load fisheriris
X = meas;
Y = species;
Mdl = fitcecoc(X,Y)

Mdl.ClassNames

CodingMat = Mdl.CodingMatrix

%��һ������ѧϰ��
% The first binary learner
Mdl.BinaryLearners{1}

%֧����������
% Support vector indices
Mdl.BinaryLearners{1}.SupportVectors

isLoss = resubLoss(Mdl)


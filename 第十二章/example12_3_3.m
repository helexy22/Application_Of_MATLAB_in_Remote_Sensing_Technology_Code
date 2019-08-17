clear;

load fisheriris
X = meas;
Y = species;
Mdl1 = fitcnb(X,Y,...
    'ClassNames',{'setosa','versicolor','virginica'})
Mdl1.DistributionParameters
Mdl1.DistributionParameters{1,2}

isLabels1 = resubPredict(Mdl1);
ConfusionMat1 = confusionmat(Y,isLabels1)

Mdl2 = fitcnb(X,Y,...
    'Distribution',{'normal','normal','kernel','kernel'},...
    'ClassNames',{'setosa','versicolor','virginica'});
Mdl2.DistributionParameters{1,2}

isLabels2 = resubPredict(Mdl2);
ConfusionMat2 = confusionmat(Y,isLabels2)

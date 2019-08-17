clear;

load fisheriris
linclass = fitcdiscr(meas,species);
meanmeas = mean(meas);
meanclass = predict(linclass,meanmeas)

quadclass = fitcdiscr(meas,species,...
    'discrimType','quadratic');
meanclass2 = predict(quadclass,meanmeas)

clear;

figure
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
meshz(Z)

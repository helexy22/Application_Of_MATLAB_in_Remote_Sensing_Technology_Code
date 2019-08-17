clear;

load fisheriris
X = meas;
[n,k] = size(X)

Mdl1 = ExhaustiveSearcher(X)

Mdl2 = KDTreeSearcher(X)

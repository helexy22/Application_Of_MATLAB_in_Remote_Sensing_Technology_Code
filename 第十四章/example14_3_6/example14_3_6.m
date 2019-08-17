clear;

A = [-1  -2  -2;
1  2  2];
b = [0;72];

x0 = [10;10;10];    % Starting guess at the solution
[x,fval] = fmincon(@myfun,x0,A,b)

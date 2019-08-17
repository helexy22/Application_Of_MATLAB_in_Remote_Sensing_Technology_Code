clear;

f = @(x)x.^3-2*x-5;
[x,fval] = fminbnd(f, 0, 2)

clear;

[x,xv] = myNewtonMethodDemo(1);

f = @(x) x.^2 - 2;
figure;ezplot(f,[0,2]);
hold on;plot(xv,f(xv),'r*');
hold on;plot(xv,f(xv),'r-');

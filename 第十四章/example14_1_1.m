clear;

x = myDichotomyDemo(1e-3,2);

f = @(x) log(x) + x^3 - 7;
figure;ezplot(f,[0,4]);
hold on;plot(x,f(x),'r*');

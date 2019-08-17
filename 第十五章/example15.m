clear;
x = valder(3,1);
y1 = x*sin(x^2)
y2 = x*sin(x*x)

clear;
figure;
%fplot(@fdf,[0 5 -1 1]);
x = (0:1e-2:5)';
y = fdf(x);
h = newplot();
plot(x,y(:,1),'r-','parent',h);
hold on;
plot(x,y(:,2),'-.','parent',h);
set(h,'YLim',[-1 1]);
title('函数及其导函数');
legend('f(x)','f''(x)');

clear;
x = newtonfdf(5)
fdf(x);

clear;
x = (0:5)';
[x,count] = newtonfdf(x)
px = (0:1e-3:5)';
pVec = fdf(px);
vec = fdf(x);
figure;plot(px, pVec(:,1),'-');
hold on;plot(x, vec(:,1),'r*');
title('x初始值分别为0、1、2、3、4、5的函数解');

clear;
x = valder(3,[1,0]);
y = valder(5,[0,1]);
f1 = x*y
f = sin(f1)

clear;
vec = fgradf(20,44,9)

clear;
newtonFJF([.1;.1;-.1])

clear;
figure;
fplot(@fseries3,[-2,2,-2,2]);
title('f(x)=cos(x)*sqrt(exp(-x*atan(x/2)+log(1+x^2)/(1+x^4)))');
legend('f(x)', 'f''(x)','f''''(x)/2!','f''''''(x)/3!');

clear;
vec = fmf(20,44,9)

clear;
h = myHessianMatrix(20,44,9)




clear;
x = 0:pi/10:2*pi;                                %自变量取值范围[0,2π]，间隔π/10
y1 = sin(x);
y2 = sin(x-0.25);
y3 = sin(x-0.5);

figure                                           %打开图窗口
plot(x,y1,'g',x,y2,'b--o',x,y3,'c*')             %绘制不同点型、线型

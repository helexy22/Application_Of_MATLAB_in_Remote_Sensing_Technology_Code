clear;
x = 0:pi/100:2*pi;                          %自变量取值范围[0,2π]，间隔π/100
y = sin(x);                                 %函数y = sin(x)
figure % opens new figure window            %打开图窗口
plot(x,y)								    %绘制正弦函数

clear;
x = linspace(-2*pi,2*pi);           %自变量取值范围[-2π,2π]，默认等分100份
y1 = sin(x);%正弦函数
y2 = cos(x);                           %余弦函数

figure%打开图窗口
plot(x,y1,'.',x,y2,'r-')                       %绘制正弦、余弦函数

function myTanTaylorSeriesDemo()
xRange = [-pi,pi];%定义域
num = 100;%定义域等分数
n = 10;%阶数

x = linspace(xRange(1),xRange(2),num);
x = x';
tanx = myTanTaylorSeries(x,n);%0,1,...,n Taylor级数
tanx = cumsum(tanx,2);%按第二维累积求和
figure;%显示在xRange范围内tan(x)
h = ezplot(@tan,xRange);
set(h, 'Color', 'm');
cmap = jet(n);
for k = 1:size(cmap,1)%显示在xRange范围内tan(x)前n项泰勒级数之和
    hold on;
    plot(x,tanx(:,k),'color',cmap(k,:));
end
title('正弦函数的泰勒级数逼近');
end


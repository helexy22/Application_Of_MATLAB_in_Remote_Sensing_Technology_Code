function myTanTaylorSeriesDemo()
xRange = [-pi,pi];%������
num = 100;%������ȷ���
n = 10;%����

x = linspace(xRange(1),xRange(2),num);
x = x';
tanx = myTanTaylorSeries(x,n);%0,1,...,n Taylor����
tanx = cumsum(tanx,2);%���ڶ�ά�ۻ����
figure;%��ʾ��xRange��Χ��tan(x)
h = ezplot(@tan,xRange);
set(h, 'Color', 'm');
cmap = jet(n);
for k = 1:size(cmap,1)%��ʾ��xRange��Χ��tan(x)ǰn��̩�ռ���֮��
    hold on;
    plot(x,tanx(:,k),'color',cmap(k,:));
end
title('���Һ�����̩�ռ����ƽ�');
end


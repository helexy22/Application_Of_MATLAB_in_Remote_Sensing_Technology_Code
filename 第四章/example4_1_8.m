clear;
x = linspace(0,10,150);                %�Ա���ȡֵ��Χ[0,10]���ȷ�150��
y = cos(5*x);

figure
plot(x,y,'Color',[0,0.7,0.9])

title('2-D Line Plot')
xlabel('x')
ylabel('cos(5x)')

clear;
t = 0:seconds(30):minutes(3);                %ʱ��0��3���ӣ����30��
y = rand(1,7);                                  %�����

plot(t,y,'DurationTickFormat','mm:ss')     %���갴����:�롱�ĸ�ʽ��ʾ

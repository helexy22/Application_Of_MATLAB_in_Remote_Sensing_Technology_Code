clear;
t = 0:seconds(30):minutes(3);                %时间0到3分钟，间隔30秒
y = rand(1,7);                                  %随机数

plot(t,y,'DurationTickFormat','mm:ss')     %坐标按“分:秒”的格式显示

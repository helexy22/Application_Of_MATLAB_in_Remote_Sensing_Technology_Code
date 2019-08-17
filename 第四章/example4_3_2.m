clear;

load count.dat
Y = count(1:10,:);

figure
bar3(Y,'grouped')
title('Grouped Style')

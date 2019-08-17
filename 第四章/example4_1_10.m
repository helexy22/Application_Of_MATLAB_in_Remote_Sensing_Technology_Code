clear;
figure % new figure
ax1 = subplot(2,1,1); % top subplot
ax2 = subplot(2,1,2); % bottom subplot

x = linspace(0,3);
y1 = sin(5*x);
y2 = sin(15*x);

plot(ax1,x,y1)
title(ax1,'Top Subplot')
ylabel(ax1,'sin(5x)')

plot(ax2,x,y2)
title(ax2,'Bottom Subplot')
ylabel(ax2,'sin(15x)')


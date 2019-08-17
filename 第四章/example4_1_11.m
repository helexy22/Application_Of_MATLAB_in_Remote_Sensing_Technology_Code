clear;
x = 0:0.01:20;
y1 = 200*exp(-0.05*x).*sin(x);
y2 = 0.8*exp(-0.5*x).*sin(10*x);

figure % new figure
[hAx,hLine1,hLine2] = plotyy(x,y1,x,y2);

title('Multiple Decay Rates')
xlabel('Time (\musec)')

ylabel(hAx(1),'Slow Decay') % left y-axis
ylabel(hAx(2),'Fast Decay') % right y-axis

clear;

[x,y,z] = cylinder(1:10);
figure
surfnorm(x,y,z)
axis([-12 12 -12 12 -0.1 1])

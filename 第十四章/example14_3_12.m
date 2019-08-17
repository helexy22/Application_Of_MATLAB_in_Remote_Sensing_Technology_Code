clear;

f = [8;1];
intcon = 2;
A = [-1,-2;-4,-1;2,1];
b = [14;-33;20];

x = intlinprog(f,intcon,A,b)
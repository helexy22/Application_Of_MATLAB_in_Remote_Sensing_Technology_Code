clear;

mu =[1 2;-3 -5];
sigma = cat(3,[2 0;0 0.5],[1,0;0,1]);
p = ones(1,2)/2;
obj = gmdistribution(mu,sigma,p);
ezsurf(@(x,y)pdf(obj,[x,y]),[-10,10],[-10,10])

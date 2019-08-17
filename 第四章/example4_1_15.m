clear;
n = 10;
x = rand(n,2);
y = rand(n,2);
x = cat(2,x,nan(n,1));
y = cat(2,y,nan(n,1));
x = reshape(x',[],1);
y = reshape(y',[],1);

plot(x,y);

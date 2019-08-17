clear;

f = [-5; -4; -6];
A = [ 1  -1   1
      3   2   4
      3   2   0];
b = [20; 42; 30];
lb = zeros(3,1);

[x,fval,exitflag,output,lambda] = linprog(f,A,b,[],[],lb);
x,lambda.ineqlin,lambda.lower


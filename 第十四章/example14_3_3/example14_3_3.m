clear;

x0 = ones(2,2);  % Make a starting guess at the solution
options = optimset('Display','off');  % Turn off display
[x,Fval,exitflag] = fsolve(@myfun,x0,options)

clear;
X = magic(3);
dlmwrite('myfile.txt',[X*5 X/5],' ');
dlmwrite('myfile.txt',X,'-append', ...
   'roffset',1,'delimiter',' ');
type myfile.txt

M = dlmread('myfile.txt')

M1 = dlmread('myfile.txt',' ',[1 0 2 3])
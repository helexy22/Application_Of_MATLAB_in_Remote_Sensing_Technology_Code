clear;

f = [-9; -5; -6; -4]; 
A = [6 3 5 2; 0 0 1 1; -1 0 1 0; 0 -1 0 1];
b = [9; 1; 0; 0];

x = bintprog(f,A,b) 
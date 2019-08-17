function [F, J] = FJF(A)
%FJF returns the value and Jacobian of a function F:R^3->R^3.
% A is a 3x1 matrix input, F is 3x1 matrix output and J is 3x3 Jacobian.

%����A��3��1�����ǳ�ʼֵ
%���F��3��1�����Ǻ���ֵ
%J��3��3���ſ˱Ⱦ���

x = valder(A(1),[1 0 0]);
y = valder(A(2),[0 1 0]);
z = valder(A(3),[0 0 1]);
f1 = 3*x-cos(y*z)-1/2;
f2 = x^2 -81*(y+0.1)^2+sin(z)+1.06;
f3 = exp(-x*y)+20*z+(10*pi-3)/3;
values = [double(f1); double(f2); double(f3)];
F = values(:,1);
J = values(:,2:4);
end

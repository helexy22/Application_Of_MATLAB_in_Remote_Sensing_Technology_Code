function root = newtonFJF(A)
%NEWTONFJF seeks a zero of the function defined in FJF using the initial A
% root estimate and Newton's method (with no exception protections).
% FJF returns the value and Jacobian of a function F:R^n->R^n where
% A is a nx1 matrix input, F is nx1 matrix output and J is nxn Jacobian.
%输入A是一个n×1的矩阵，是初始值
%输出F也是n×1的矩阵，是函数值
%J是n×n的雅克比矩阵，是偏导函数矩阵

delta = 1;
while max(abs(delta)) > .000001
[F,J] = FJF(A);
delta = J\F;   % solves the linear system JX=F for X
%解线性方程JX=F，X是未知数
    A = A - delta;
end
root = A;
end

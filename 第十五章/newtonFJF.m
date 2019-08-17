function root = newtonFJF(A)
%NEWTONFJF seeks a zero of the function defined in FJF using the initial A
% root estimate and Newton's method (with no exception protections).
% FJF returns the value and Jacobian of a function F:R^n->R^n where
% A is a nx1 matrix input, F is nx1 matrix output and J is nxn Jacobian.
%����A��һ��n��1�ľ����ǳ�ʼֵ
%���FҲ��n��1�ľ����Ǻ���ֵ
%J��n��n���ſ˱Ⱦ�����ƫ����������

delta = 1;
while max(abs(delta)) > .000001
[F,J] = FJF(A);
delta = J\F;   % solves the linear system JX=F for X
%�����Է���JX=F��X��δ֪��
    A = A - delta;
end
root = A;
end

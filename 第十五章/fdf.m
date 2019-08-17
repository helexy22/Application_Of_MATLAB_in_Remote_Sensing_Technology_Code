function vec = fdf(a)
%FDF takes a scalar and returns the double vector [ f(a), f'(a) ]
%   where f is defined in normal syntax below.
%函数fdf作用是输入一个关于x的初始值a
%按照给定的函数式，生成对应的函数值和导函数值
%最后函数值和导函数值按顺序存储在vec变量中，形式是[f(a),f’(a)]

a = a(:);%构建一个valder类的对象，并初始化
n = size(a,1);
x = valder(a,ones(n,1));

y = exp(-sqrt(x))*sin(x*log(1+x^2));%按照原函数的形式写出函数，
%通过重载运算，得到的仍然是valder类的对象

vec = double(y);%将得到的valder类的对象y转换为矩阵vec，
%调用的是valder类的重载方法double
end

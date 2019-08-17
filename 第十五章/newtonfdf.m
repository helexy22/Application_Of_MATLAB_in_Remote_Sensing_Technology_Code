% function root = newtonfdf(a)
% %NEWTON seeks a zero of the function defined in fdf using the
% %initial aroot estimate and Newton's method
% %(with no exception protections).
% % fdf uses @valder to return a vector of function and derivative values.
% %根据一阶自动微分类valder，得到函数的函数值和导数值，再进行牛顿法迭代运算。
% %delta表示自变量的迭代改正数
% %delta初始值设为1，不满足设置的改正数阈值，使第一次迭代能顺利进行。
%
% delta = 1;
% while abs(delta) > .000001%迭代终止条件，改正数小于等于阈值.000001
%     fvec = fdf(a);%计算函数值和导函数值
%     delta = fvec(1)/fvec(2); %value/derivative
%     %牛顿法迭代公式
%     a = a - delta;
% end
% root = a;%牛顿法迭代出结果
% end

function [root,count] = newtonfdf(a)
tol = 1e-6;%改正数阈值
maxCount = 1e2;%最大迭代次数
n = size(a,1);%输入初始值个数
loc = (1:n)';%初始值位置线性索引
root = nan(n,1);%初始化迭代结果的矩阵
count = nan(n,1);%初始化迭代结果的迭代次数矩阵
for k = 1:maxCount%迭代过程
    fvec = fdf(a);%计算函数值和导函数值
    delta = fvec(:,1) ./ fvec(:,2); %value/derivative
    %牛顿法迭代改正数
    ind = abs(delta) > tol;%判断是否满足改正数阈值
    goodLoc = loc(~ind);%记录满足改正数阈值对应的原始线性索引
    root(goodLoc) = a(~ind);%设置最终未知数矩阵对应索引的值，
    %为当前迭代满足阈值条件的值。
    count(goodLoc) = k;%设置最终迭代次数矩阵对应索引的值为当前迭代次数
    loc = loc(ind);%计算不满足改正数阈值条件的原始线性索引
    if isempty(loc)%判断不满足条件的线性索引是否为空，为空时，跳出循环
        break;
    end
    a = a(ind) - delta(ind);%根据牛顿法迭代公式，
    %计算不满足阈值条件的初始值改正后的新初始值
end
end

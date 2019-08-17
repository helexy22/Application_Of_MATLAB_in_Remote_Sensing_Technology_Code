function x = myDichotomyDemo(x1,x2)
%在[x1,x2]区间内单调的任意一个函数
y = @(x) log(x) + x^3 - 7;
%二分法迭代次数
count = 0;
%二分法最大迭代次数
maxCount = 1e2;
%上下界差异阈值
xTol = 1e-15;
%二分法迭代
y1 = y(x1);
y2 = y(x2);
while true
    %迭代次数增加1
    count = count + 1;
    %二分之一处
    x = (x1 + x2) / 2;
    %二分之一处的函数值
    yn = y(x);
    %判断二分之一处是新的上界，还是新的下界
    if yn * y1 > 0
        x1 = x;
        y1 = yn;
    end
    if yn * y2 > 0
        x2 = x;
        y2 = yn;
    end
    %计算上下界差异
    dx = abs(x1 - x2);
    %迭代收敛条件
    if count > maxCount || dx <= xTol
        break;
    end
end
y(x)
end
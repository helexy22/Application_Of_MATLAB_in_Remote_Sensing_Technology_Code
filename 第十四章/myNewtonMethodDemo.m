function [x,xVector] = myNewtonMethodDemo(x0)
%x阈值
xTol = 1e-7;
%函数阈值
funTol = 1e-15;
%最大迭代次数
maxCount = 1e2;
%是否收敛
bConverge = false;
%收集所有迭代过程的x
xVector = [];
%迭代过程
for k = 1:maxCount
    %显示迭代过程的值
    disp(num2str(x0,'%10.15f'));
    xVector = cat(1,xVector,x0);
    y0 = myFunction(x0);
    %判断函数是否满足阈值
    if abs(y0) <= funTol
        bConverge = true;
        x = x0;
        break;
    end
    %计算导函数值
    dy0 = myDerivedFunction(x0);
    %分母为0时的异常处理
    if dy0 == 0
        error('The value of derived function is zero.');
    end
    %牛顿法迭代公式
    x = x0 - y0/dy0;
    %判断x是否满足阈值
    if abs(x - x0) <= xTol
        bConverge = true;
        break;
    else
        x0 = x;
    end
end
%迭代是否收敛
if bConverge
    disp('Converge.');
    y = myFunction(x)
else
    disp('Fail to Converge.');
end
end

function y = myFunction(x)
%原函数
y = x^2 - 2;
end

function y = myDerivedFunction(x)
%原函数myFunction的导函数
y = 2*x;
end
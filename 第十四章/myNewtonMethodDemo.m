function [x,xVector] = myNewtonMethodDemo(x0)
%x��ֵ
xTol = 1e-7;
%������ֵ
funTol = 1e-15;
%����������
maxCount = 1e2;
%�Ƿ�����
bConverge = false;
%�ռ����е������̵�x
xVector = [];
%��������
for k = 1:maxCount
    %��ʾ�������̵�ֵ
    disp(num2str(x0,'%10.15f'));
    xVector = cat(1,xVector,x0);
    y0 = myFunction(x0);
    %�жϺ����Ƿ�������ֵ
    if abs(y0) <= funTol
        bConverge = true;
        x = x0;
        break;
    end
    %���㵼����ֵ
    dy0 = myDerivedFunction(x0);
    %��ĸΪ0ʱ���쳣����
    if dy0 == 0
        error('The value of derived function is zero.');
    end
    %ţ�ٷ�������ʽ
    x = x0 - y0/dy0;
    %�ж�x�Ƿ�������ֵ
    if abs(x - x0) <= xTol
        bConverge = true;
        break;
    else
        x0 = x;
    end
end
%�����Ƿ�����
if bConverge
    disp('Converge.');
    y = myFunction(x)
else
    disp('Fail to Converge.');
end
end

function y = myFunction(x)
%ԭ����
y = x^2 - 2;
end

function y = myDerivedFunction(x)
%ԭ����myFunction�ĵ�����
y = 2*x;
end
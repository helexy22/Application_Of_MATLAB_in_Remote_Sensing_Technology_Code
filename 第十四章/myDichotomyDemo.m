function x = myDichotomyDemo(x1,x2)
%��[x1,x2]�����ڵ���������һ������
y = @(x) log(x) + x^3 - 7;
%���ַ���������
count = 0;
%���ַ�����������
maxCount = 1e2;
%���½������ֵ
xTol = 1e-15;
%���ַ�����
y1 = y(x1);
y2 = y(x2);
while true
    %������������1
    count = count + 1;
    %����֮һ��
    x = (x1 + x2) / 2;
    %����֮һ���ĺ���ֵ
    yn = y(x);
    %�ж϶���֮һ�����µ��Ͻ磬�����µ��½�
    if yn * y1 > 0
        x1 = x;
        y1 = yn;
    end
    if yn * y2 > 0
        x2 = x;
        y2 = yn;
    end
    %�������½����
    dx = abs(x1 - x2);
    %������������
    if count > maxCount || dx <= xTol
        break;
    end
end
y(x)
end
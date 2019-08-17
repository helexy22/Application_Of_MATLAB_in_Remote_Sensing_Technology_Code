% function root = newtonfdf(a)
% %NEWTON seeks a zero of the function defined in fdf using the
% %initial aroot estimate and Newton's method
% %(with no exception protections).
% % fdf uses @valder to return a vector of function and derivative values.
% %����һ���Զ�΢����valder���õ������ĺ���ֵ�͵���ֵ���ٽ���ţ�ٷ��������㡣
% %delta��ʾ�Ա����ĵ���������
% %delta��ʼֵ��Ϊ1�����������õĸ�������ֵ��ʹ��һ�ε�����˳�����С�
%
% delta = 1;
% while abs(delta) > .000001%������ֹ������������С�ڵ�����ֵ.000001
%     fvec = fdf(a);%���㺯��ֵ�͵�����ֵ
%     delta = fvec(1)/fvec(2); %value/derivative
%     %ţ�ٷ�������ʽ
%     a = a - delta;
% end
% root = a;%ţ�ٷ����������
% end

function [root,count] = newtonfdf(a)
tol = 1e-6;%��������ֵ
maxCount = 1e2;%����������
n = size(a,1);%�����ʼֵ����
loc = (1:n)';%��ʼֵλ����������
root = nan(n,1);%��ʼ����������ľ���
count = nan(n,1);%��ʼ����������ĵ�����������
for k = 1:maxCount%��������
    fvec = fdf(a);%���㺯��ֵ�͵�����ֵ
    delta = fvec(:,1) ./ fvec(:,2); %value/derivative
    %ţ�ٷ�����������
    ind = abs(delta) > tol;%�ж��Ƿ������������ֵ
    goodLoc = loc(~ind);%��¼�����������ֵ��Ӧ��ԭʼ��������
    root(goodLoc) = a(~ind);%��������δ֪�������Ӧ������ֵ��
    %Ϊ��ǰ����������ֵ������ֵ��
    count(goodLoc) = k;%�������յ������������Ӧ������ֵΪ��ǰ��������
    loc = loc(ind);%���㲻�����������ֵ������ԭʼ��������
    if isempty(loc)%�жϲ��������������������Ƿ�Ϊ�գ�Ϊ��ʱ������ѭ��
        break;
    end
    a = a(ind) - delta(ind);%����ţ�ٷ�������ʽ��
    %���㲻������ֵ�����ĳ�ʼֵ��������³�ʼֵ
end
end

function c = test(a,varargin)			%�ɱ�����
num = length(varargin);
if num == 0                             %�������Ϊ0
    b = 1;
elseif num == 1                         %�������Ϊ1
    b = varargin{1};
else									%�����������1
    error('error');
end
c = a + b;
end
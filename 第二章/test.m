function c = test(a,varargin)			%可变输入
num = length(varargin);
if num == 0                             %输入个数为0
    b = 1;
elseif num == 1                         %输入个数为1
    b = varargin{1};
else									%输入个数大于1
    error('error');
end
c = a + b;
end
function vec = fdf(a)
%FDF takes a scalar and returns the double vector [ f(a), f'(a) ]
%   where f is defined in normal syntax below.
%����fdf����������һ������x�ĳ�ʼֵa
%���ո����ĺ���ʽ�����ɶ�Ӧ�ĺ���ֵ�͵�����ֵ
%�����ֵ�͵�����ֵ��˳��洢��vec�����У���ʽ��[f(a),f��(a)]

a = a(:);%����һ��valder��Ķ��󣬲���ʼ��
n = size(a,1);
x = valder(a,ones(n,1));

y = exp(-sqrt(x))*sin(x*log(1+x^2));%����ԭ��������ʽд��������
%ͨ���������㣬�õ�����Ȼ��valder��Ķ���

vec = double(y);%���õ���valder��Ķ���yת��Ϊ����vec��
%���õ���valder������ط���double
end

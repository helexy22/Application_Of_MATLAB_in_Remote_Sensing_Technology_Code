function rI = myImrotate(I,angle,varargin)
%��ȡ��Ҫ�ļ������
[method,bbox] = ParseInputs(varargin{:});
%�Ƕ�ת��Ϊ����
angle = angle * pi / 180;
%�ɽ��Ӱ��Χ�����㼸��ת����ϵ
R = CalculateTransformMatrix(angle);
%������Ӱ��
inSz = size(I);
if strcmpi(bbox,'loose')
    %���ĸ��ǵ�任���λ�ã�������Ӱ��Ĵ�С
    xIn = [1;1;inSz(2);inSz(2)];
    yIn = [1;inSz(1);inSz(1);1];
    [xOut,yOut] = In2Out(R,xIn,yIn);
    %����ȡ��
    xOutMin = floor( min(xOut) );
    yOutMin = floor( min(yOut) );
    xOutMax = ceil( max(xOut) );
    yOutMax = ceil( max(yOut) );
    outSz = [yOutMax, xOutMax] - [yOutMin, xOutMin] + 1;
    %��¼���Ӱ������Ͻǵ㣬�����ԭʼӰ������ϵ��λ��
    xOffset = xOutMin;
    yOffset = yOutMin;
elseif strcmpi(bbox,'crop')
    outSz = inSz(1:2);
    xOffset = 1;
    yOffset = 1;
end
%ԭʼӰ����������
dataType = class(I);
%������
bandNum = size(I,3);
rI = zeros([outSz,bandNum],dataType);
%������Ӱ��ĸ�����λ��
[xOut,yOut] = meshgrid(1:outSz(2),1:outSz(1));
%������Ӱ������㣬�����ԭʼӰ������ϵ��λ��
xOut = xOut(:) - 1 + xOffset;
yOut = yOut(:) - 1 + yOffset;
[xIn,yIn] = Out2In(R,xOut,yOut);
%��Ӧ��ԭʼӰ������
for k = 1:size(I,3)%�����α���
	%�ı��������ͣ����㺯��interp2Ҫ�󣬹�����ʱ����tmp
    tmp = double( I(:,:,k) ); 
	%����method�������ڲ�Ҷ�
    tmp = interp2(tmp, xIn, yIn, method);
    rI(:,:,k) = reshape(tmp, outSz);
end
end

function [method,bbox] = ParseInputs(varargin)
inputNum = length(varargin);%��������ĸ���
method = 'nearest';
bbox = 'loose';
switch inputNum
    case 0
    case 1
        method = varargin{1};
    case 2
        method = varargin{1};
        bbox = varargin{2};
    otherwise
        error('Too many input arguments.');
end
end

function R = CalculateTransformMatrix(angle)
R = [
    cos(angle), -sin(angle);
    sin(angle),  cos(angle);
    ];
end

function [xout,yout] = In2Out(R,xin,yin)
%����Ĭ�������x1,y1�ֱ���1����������n-by-1�ľ���
p = [xin,yin] * R;
xout = p(:,1);
yout = p(:,2);
end

function [xin,yin] = Out2In(R,xout,yout)
p = [xout,yout] / R;
xin = p(:,1);
yin = p(:,2);
end

function rI = myImrotate(I,angle,varargin)
%获取必要的计算参数
[method,bbox] = ParseInputs(varargin{:});
%角度转换为弧度
angle = angle * pi / 180;
%由结果影像范围，计算几何转换关系
R = CalculateTransformMatrix(angle);
%计算结果影像
inSz = size(I);
if strcmpi(bbox,'loose')
    %由四个角点变换后的位置，计算结果影像的大小
    xIn = [1;1;inSz(2);inSz(2)];
    yIn = [1;inSz(1);inSz(1);1];
    [xOut,yOut] = In2Out(R,xIn,yIn);
    %像素取整
    xOutMin = floor( min(xOut) );
    yOutMin = floor( min(yOut) );
    xOutMax = ceil( max(xOut) );
    yOutMax = ceil( max(yOut) );
    outSz = [yOutMax, xOutMax] - [yOutMin, xOutMin] + 1;
    %记录结果影像的左上角点，相对于原始影像坐标系的位置
    xOffset = xOutMin;
    yOffset = yOutMin;
elseif strcmpi(bbox,'crop')
    outSz = inSz(1:2);
    xOffset = 1;
    yOffset = 1;
end
%原始影像数据类型
dataType = class(I);
%波段数
bandNum = size(I,3);
rI = zeros([outSz,bandNum],dataType);
%计算结果影像的格网点位置
[xOut,yOut] = meshgrid(1:outSz(2),1:outSz(1));
%计算结果影像格网点，相对于原始影像坐标系的位置
xOut = xOut(:) - 1 + xOffset;
yOut = yOut(:) - 1 + yOffset;
[xIn,yIn] = Out2In(R,xOut,yOut);
%对应的原始影像坐标
for k = 1:size(I,3)%按波段遍历
	%改变数据类型，满足函数interp2要求，构造临时变量tmp
    tmp = double( I(:,:,k) ); 
	%采用method方法，内插灰度
    tmp = interp2(tmp, xIn, yIn, method);
    rI(:,:,k) = reshape(tmp, outSz);
end
end

function [method,bbox] = ParseInputs(varargin)
inputNum = length(varargin);%输入参数的个数
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
%这里默认输入的x1,y1分别是1列向量，即n-by-1的矩阵
p = [xin,yin] * R;
xout = p(:,1);
yout = p(:,2);
end

function [xin,yin] = Out2In(R,xout,yout)
p = [xout,yout] / R;
xin = p(:,1);
yin = p(:,2);
end

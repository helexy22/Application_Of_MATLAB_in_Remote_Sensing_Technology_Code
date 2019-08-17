function [x,y] = myBwboundaries(bw)
count = 0;%循环次数
%计算四连通性模板
h = ones(3);
h([1;3;7;9]) = 0;
sz = size(bw);%影像大小
%计算像素角点单维坐标
x = 0.5 : 0.5 : sz(2)+0.5;
y = 0.5 : 0.5 : sz(1)+0.5;
%四个方向各外扩一个像素，填充0
I = zeros(sz + 2);
I(2:end-1,2:end-1) = bw;
%计算外扩后的像素角点单维坐标
x = x + 1;
y = y + 1;
%计算角点格网
[x,y] = meshgrid(x,y);
%内插角点灰度
bw = interp2(I,x,y);
%确定影像边缘位置
bw = bw > 0 & bw < 1;
%计算内插后影像大小
sz = size(bw);
%存储边缘信息，元胞数组
cBoundary = cell(0,1);
%逐层搜索边缘，当影像全为0时，停止搜索
while any(bw(:))
    count = count + 1;%循环次数
    %计算各像素四连通性
    val = imfilter(double(bw),h);
    %找出上下左右都连通的点的逻辑索引
    ind = val == 5;
    %计算最外层边缘
    iCellBoundary = bwboundaries(bw,4);
    if count > 1%排除循环超过一次后，形成的单点
        cLength = cellfun('size',iCellBoundary,1);
        ind = cLength == 2;
        iCellBoundary(ind) = [];
    end
    %合并到整体边缘
    cBoundary = cat(1,cBoundary,iCellBoundary);
    %计算边缘像素行列
    rc = cat(1,cBoundary{:});
    %计算边缘像素在影像中的线性索引
    loc = sub2ind(sz, rc(:,1), rc(:,2));
    %将边缘像素变为0
    bw(loc) = false;
    %将上下左右都连通的点变为1，有两条边缘都经过该点
    bw(ind) = true;
end
%在边界之间插入nan分隔
boundaryNum = length(cBoundary);
cRowCol = cell(boundaryNum * 2, 1);
cRowCol(1:2:end) = cBoundary;
cRowCol(2:2:end) = {nan(1,2)};
rc = cat(1,cRowCol{:});
%去除原始影像中任一方向上整像素位置的点
ind = mod(rc,2) == 0;
ind = any(ind,2);
rc(ind,:) = [];
%换算到原始影像坐标
rc = rc / 2;
x = rc(:,2);
y = rc(:,1);
end



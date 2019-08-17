function [x,y] = myBlockBwboundaries(srcPath)
blockLength = 128;
nanVal = 0;
borderLength = 1;
x = [];
y = [];
xNew = [];
yNew = [];
imgInfo = imfinfo(srcPath);
sz = [imgInfo.Height, imgInfo.Width];
blockSz = ceil(sz ./ blockLength);
blockNum = prod(blockSz);
for k = 1:blockNum
    [r,c] = ind2sub(blockSz,k);
    xmin = (c - 1) * blockLength + 1;
    ymin = (r - 1) * blockLength + 1;
    xmax = min(c * blockLength,sz(2));
    ymax = min(r * blockLength,sz(1));
    bxmin = max(xmin - borderLength, 1);
    bymin = max(ymin - borderLength, 1);
    bxmax = min(xmax + borderLength, sz(2));
    bymax = min(ymax + borderLength, sz(1));
    I = imread(srcPath,'PixelRegion',{[bymin,bymax],[bxmin,bxmax]}); 
    bw = ~all(I == nanVal,3);
    cBlockBoundary = bwboundaries(bw);%元胞数组，行列
    boundaryNum = length(cBlockBoundary);%边界数量
    if boundaryNum ~= 0
        cBlockRowCol = cell(boundaryNum * 2, 1);
        cBlockRowCol(1:2:end) = cBlockBoundary;%将存储边界的元胞数组，间隔插入
        cBlockRowCol(2:2:end) = {nan(1,2)};%间隔内填充无效值，作为分隔符
        blockRowCol = cat(1,cBlockRowCol{:});%影像块中的相对行列，各个形状的边界采用nan分隔
        xBlock = blockRowCol(:,2) + bxmin - 1;%整体影像的x坐标
        yBlock = blockRowCol(:,1) + bymin - 1;%整体影像的y坐标
        [x,y] = polybool('+',x,y,xBlock,yBlock);
        xNew = cat(1,xNew,xBlock);
        yNew = cat(1,yNew,yBlock);
    end
end
save 1.mat xNew yNew;
end
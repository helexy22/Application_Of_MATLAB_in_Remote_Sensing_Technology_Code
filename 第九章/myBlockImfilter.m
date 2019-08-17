function dstI = myBlockImfilter(srcPath,filterTemplate)
blockLength = 128;
nanVal = 0;
areaTol = 100;
dataType = 'uint8';
borderLength = floor( max( size(filterTemplate) ) / 2);
borderLength = max(borderLength, areaTol);
imgInfo = imfinfo(srcPath);
bandCount = imgInfo.BitDepth / 8;
sz = [imgInfo.Height, imgInfo.Width];
dstI = zeros([sz,bandCount],dataType);
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
    bw = imfill(bw,'holes');
    bw = bwareaopen(bw, areaTol);
    I = double(I);
    if nanVal ~= 0
        iSz = size(I);
        I = reshape(I,[],bandCount);
        I(~bw,:) = 0;
        I = reshape(I,iSz);
    end
    weightVal = imfilter(double(bw), filterTemplate);
    I = imfilter(I, filterTemplate);
    I = bsxfun(@rdivide, I, weightVal);
    I = cast(I,dataType);
    I = I(ymin-bymin+1:ymax-bymin+1, xmin-bxmin+1:xmax-bxmin+1, :);
    dstI(ymin:ymax, xmin:xmax, :) = I;
end
end
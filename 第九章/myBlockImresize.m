function dstI = myBlockImresize(srcPath,ratio,varargin)
blockLength = 20;
if isempty(varargin)
    resampleMethod = 'bicubic';
else
    resampleMethod = varargin{1};
end

names = {'nearest', 'bilinear', 'bicubic', 'box', ...
    'triangle', 'cubic', 'lanczos2', 'lanczos3'};
kernels = {@box, @triangle, @cubic, @box, @triangle, @cubic, ...
    @lanczos2, @lanczos3};
widths = [1.0, 2.0, 4.0, 1.0, 2.0, 4.0, 4.0, 6.0];
ind = ismember(names,resampleMethod);
kernel = kernels{ind};
kernel_width = widths(ind);
if strcmpi(resampleMethod,'nearest')
    antialiasing = false;
else
    antialiasing = true;
end

imgInfo = imfinfo(srcPath);
srcSz = [imgInfo.Height, imgInfo.Width];
bandCount = imgInfo.BitDepth / 8;
dstSz = ceil(srcSz * ratio);
blockSz = ceil(dstSz ./ blockLength);
dstI = zeros([dstSz,bandCount],'uint8');
blockNum = prod(blockSz);
for iBlock = 1:blockNum
    [r,c] = ind2sub(blockSz,iBlock);
    dstRowColMin = ([r,c] - 1) * blockLength + 1;
    dstRowColMax = [r,c] * blockLength;
    dstRowColMax = min([dstRowColMax;dstSz]);
    weights = cell(1,2);
    indices = cell(1,2);
    srcRowColMin = nan(1,2);
    srcRowColMax = nan(1,2);
    for k = 1:2
        [weights{k}, indices{k}] = contributions(srcSz(k), dstRowColMin(k):dstRowColMax(k), ratio, kernel, kernel_width, antialiasing);
        srcRowColMin(k) = min(indices{k}(:));
        srcRowColMax(k) = max(indices{k}(:));
        indices{k} = indices{k} - srcRowColMin(k) + 1;
    end
    I = imread(srcPath,'PixelRegion',{[srcRowColMin(1),srcRowColMax(1)],[srcRowColMin(2),srcRowColMax(2)]});
    if isPureNearestNeighborComputation(weights{1}) && isPureNearestNeighborComputation(weights{2})
        I = resizeTwoDimUsingNearestNeighbor(I, indices);
    else
        for k = 1:2
            I = resizeAlongDim(I, k, weights{k}, indices{k});
        end
    end
    dstI(dstRowColMin(1) : dstRowColMax(1), dstRowColMin(2) : dstRowColMax(2), :) = I;
end
end

%=====================================================================
function out = resizeAlongDim(in, dim, weights, indices)
% Resize along a specified dimension
%
% in           - input array to be resized
% dim          - dimension along which to resize
% weights      - weight matrix; row k is weights for k-th output pixel
% indices      - indices matrix; row k is indices for k-th output pixel

if isPureNearestNeighborComputation(weights)
    out = resizeAlongDimUsingNearestNeighbor(in, dim, indices);
    return
end

out_length = size(weights, 1);

size_in = size(in);
size_in((end + 1) : dim) = 1;

if (ndims(in) > 3)
    % Reshape in to be a three-dimensional array.  The size of this
    % three-dimensional array is the variable pseudo_size_in below.
    %
    % Final output will be consistent with the original input.
    pseudo_size_in = [size_in(1:2) prod(size_in(3:end))];
    in = reshape(in, pseudo_size_in);
end

% The 'out' will be uint8 if 'in' is logical
% Otherwise 'out' datatype will be same as 'in' datatype
out = imresizemex(in, weights', indices', dim);

if (ndims(in) > 3)
    % Restoring final output to expected size
    size_out = size_in;
    size_out(dim) = out_length;
    out = reshape(out, size_out);
end
end
%---------------------------------------------------------------------

%=====================================================================
function tf = isPureNearestNeighborComputation(weights)
% True if there is only one column of weights, and if the weights are
% all one.  For this case, the resize can be done using a quick
% indexing operation.

one_weight_per_pixel = size(weights, 2) == 1;
tf = one_weight_per_pixel && all(weights == 1);
end
%---------------------------------------------------------------------

%=====================================================================
function out = resizeAlongDimUsingNearestNeighbor(in, dim, indices)
% Resize using a multidimensional indexing operation.  Preserve the
% array along all dimensions other than dim.  Along dim, use the
% indices input vector as a subscript vector.

num_dims = max(ndims(in), dim);
subscripts = {':'};
subscripts = subscripts(1, ones(1, num_dims));
subscripts{dim} = indices;
out = in(subscripts{:});
end
%---------------------------------------------------------------------

%=====================================================================
function out = resizeTwoDimUsingNearestNeighbor(in, indices)
% Resize row and column dimensions simultaneously using a single
% multidimensional indexing operation.

subscripts = indices;
subscripts(3:ndims(in)) = {':'};
out = in(subscripts{:});
end
%---------------------------------------------------------------------

%=====================================================================
function [weights, indices] = contributions(in_length, out_vector, ...
    scale, kernel, ...
    kernel_width, antialiasing)


if (scale < 1) && (antialiasing)
    % Use a modified kernel to simultaneously interpolate and
    % antialias.
    h = @(x) scale * kernel(scale * x);
    kernel_width = kernel_width / scale;
else
    % No antialiasing; use unmodified kernel.
    h = kernel;
end

% Output-space coordinates.
x = out_vector';

% Input-space coordinates. Calculate the inverse mapping such that 0.5
% in output space maps to 0.5 in input space, and 0.5+scale in output
% space maps to 1.5 in input space.
u = x/scale + 0.5 * (1 - 1/scale);

% What is the left-most pixel that can be involved in the computation?
left = floor(u - kernel_width/2);

% What is the maximum number of pixels that can be involved in the
% computation?  Note: it's OK to use an extra pixel here; if the
% corresponding weights are all zero, it will be eliminated at the end
% of this function.
P = ceil(kernel_width) + 2;

% The indices of the input pixels involved in computing the k-th output
% pixel are in row k of the indices matrix.
indices = bsxfun(@plus, left, 0:P-1);

% The weights used to compute the k-th output pixel are in row k of the
% weights matrix.
weights = h(bsxfun(@minus, u, indices));

% Normalize the weights matrix so that each row sums to 1.
weights = bsxfun(@rdivide, weights, sum(weights, 2));

% Clamp out-of-range indices; has the effect of replicating end-points.
indices = min(max(1, indices), in_length);

% If a column in weights is all zero, get rid of it.
kill = find(~any(weights, 1));
if ~isempty(kill)
    weights(:,kill) = [];
    indices(:,kill) = [];
end
end
%---------------------------------------------------------------------

%=====================================================================
function f = cubic(x)
% See Keys, "Cubic Convolution Interpolation for Digital Image
% Processing," IEEE Transactions on Acoustics, Speech, and Signal
% Processing, Vol. ASSP-29, No. 6, December 1981, p. 1155.

absx = abs(x);
absx2 = absx.^2;
absx3 = absx.^3;

f = (1.5*absx3 - 2.5*absx2 + 1) .* (absx <= 1) + ...
    (-0.5*absx3 + 2.5*absx2 - 4*absx + 2) .* ...
    ((1 < absx) & (absx <= 2));
end
%---------------------------------------------------------------------

%=====================================================================
function f = box(x)
f = (-0.5 <= x) & (x < 0.5);
end
%---------------------------------------------------------------------

%=====================================================================
function f = triangle(x)
f = (x+1) .* ((-1 <= x) & (x < 0)) + (1-x) .* ((0 <= x) & (x <= 1));
end
%---------------------------------------------------------------------

%=====================================================================
function f = lanczos2(x)
% See Graphics Gems, Andrew S. Glasser (ed), Morgan Kaufman, 1990,
% pp. 156-157.

f = (sin(pi*x) .* sin(pi*x/2) + eps) ./ ((pi^2 * x.^2 / 2) + eps);
f = f .* (abs(x) < 2);
end
%---------------------------------------------------------------------

%=====================================================================
function f = lanczos3(x)
% See Graphics Gems, Andrew S. Glasser (ed), Morgan Kaufman, 1990,
% pp. 157-158.

f = (sin(pi*x) .* sin(pi*x/3) + eps) ./ ((pi^2 * x.^2 / 3) + eps);
f = f .* (abs(x) < 3);
end
%---------------------------------------------------------------------


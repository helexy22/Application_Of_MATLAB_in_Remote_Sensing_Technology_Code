clear;

% Compute the ordinary Euclidean distance.
%计算一般欧式距离
X = randn(100, 5);
D = pdist(X,'euclidean');  % euclidean distance

% Compute the Euclidean distance with each coordinate
% difference scaled by the standard deviation.
%用标准差来计算每个坐标差的欧氏距离
Dstd = pdist(X,'seuclidean');

% Use a function handle to compute a distance that weights
% each coordinate contribution differently.
%用一个函数句柄来计算每个维度的坐标占不同权重的距离
Wgts = [.1 .3 .3 .2 .1];     % coordinate weights
weuc = @(XI,XJ,W)(sqrt(bsxfun(@minus,XI,XJ).^2 * W'));
Dwgt = pdist(X, @(Xi,Xj) weuc(Xi,Xj,Wgts));

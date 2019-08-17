clear;

% Compute the ordinary Euclidean distance.
%����һ��ŷʽ����
X = randn(100, 5);
D = pdist(X,'euclidean');  % euclidean distance

% Compute the Euclidean distance with each coordinate
% difference scaled by the standard deviation.
%�ñ�׼��������ÿ��������ŷ�Ͼ���
Dstd = pdist(X,'seuclidean');

% Use a function handle to compute a distance that weights
% each coordinate contribution differently.
%��һ���������������ÿ��ά�ȵ�����ռ��ͬȨ�صľ���
Wgts = [.1 .3 .3 .2 .1];     % coordinate weights
weuc = @(XI,XJ,W)(sqrt(bsxfun(@minus,XI,XJ).^2 * W'));
Dwgt = pdist(X, @(Xi,Xj) weuc(Xi,Xj,Wgts));

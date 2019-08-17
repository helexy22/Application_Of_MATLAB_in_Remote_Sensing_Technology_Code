clear;

%加载立体匹配点对数据
load stereoPointPairs;
%通过已知的同名点线性索引得到同名点对
inlierPts1 = matched_points1(knownInliers, :);
inlierPts2 = matched_points2(knownInliers, :);

%采用Normalized Eight-Point，估计基本矩阵
fNorm8Point = estimateFundamentalMatrix(...
    inlierPts1, inlierPts2,'Method','Norm8Point')

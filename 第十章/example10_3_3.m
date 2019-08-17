clear;

load stereoPointPairs;%加载立体匹配点对数据

fRANSAC = estimateFundamentalMatrix(...
    matched_points1, matched_points2,...
    'Method', 'RANSAC', ...%用RANSAC方法，估计基础矩阵
    'NumTrials', 2000, ...                               %最大试验次数2000，
    'DistanceThreshold', 1e-4);%距离阈值1e-4，

clear;

load stereoPointPairs;%加载立体匹配点对数据
[fLMedS, inliers] = estimateFundamentalMatrix(...%用LMS方法，估计基础矩阵，
    matched_points1,matched_points2, 'NumTrials', 2000);%最大试验次数2000

I1 = imread('viprectification_deskLeft.png');%读取影像
I2 = imread('viprectification_deskRight.png');

figure;%显示原始匹配点
showMatchedFeatures(I1, I2, matched_points1, matched_points2,...
    'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');

figure;%显示符合几何关系的匹配点
showMatchedFeatures(I1,I2,...
    matched_points1(inliers,:),matched_points2(inliers,:),...
    'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');

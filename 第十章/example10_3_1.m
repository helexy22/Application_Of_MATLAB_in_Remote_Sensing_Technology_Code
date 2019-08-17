clear;

I1 = rgb2gray(imread('viprectification_deskLeft.png'));%读影像，
%RGB图像转换为灰度图像
I2 = rgb2gray(imread('viprectification_deskRight.png'));

cornerDetector = vision.CornerDetector;%找到角点
points1 = step(cornerDetector, I1);
points2 = step(cornerDetector, I2);

[features1, valid_points1] = extractFeatures(I1, points1);%提取邻域窗口特征向量
[features2, valid_points2] = extractFeatures(I2, points2);

index_pairs = matchFeatures(features1, features2);%匹配特征向量
matched_points1 = valid_points1(index_pairs(:, 1), :);%检索匹配的特征点位置
matched_points2 = valid_points2(index_pairs(:, 2), :);

figure; %显示匹配同名点，在忽略错误匹配点外，可以出看出图像的平移效果
showMatchedFeatures(I1, I2, matched_points1, matched_points2);

clear;

I1 = imread('cameraman.tif');%读图像，
%并生成一个顺时针旋转20度并放大1.2倍的影像
I2 = imresize(imrotate(I1,-20), 1.2);

points1 = detectSURFFeatures(I1);%探测SURF特征点
points2 = detectSURFFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);%获取描述SURF特征点的特征向量
[f2, vpts2] = extractFeatures(I2, points2);

index_pairs = matchFeatures(f1, f2, 'Prenormalized', false);%匹配SURF特征向量

matched_pts1 = vpts1(index_pairs(:, 1));%检索匹配的特征点位置
matched_pts2 = vpts2(index_pairs(:, 2));

figure; %显示匹配的特征点，忽略其中的错误匹配点，
%可以看出图像的旋转和缩放效果
showMatchedFeatures(I1,I2,matched_pts1,matched_pts2);
legend('matched points 1','matched points 2');

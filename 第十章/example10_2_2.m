clear;

I = imread('cameraman.tif');%读图像
points = detectSURFFeatures(I);%探测图像SURF特征点
[features, valid_points] = extractFeatures(I, points);
%获取描述图像的SURF特征点的特征向量
figure; imshow(I);%显示图像
hold on;%显示有效特征点中最强的10个特征点，
%显示SURF特征方向
plot(valid_points.selectStrongest(10),'showOrientation',true);

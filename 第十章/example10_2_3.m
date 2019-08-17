clear;

%读图像
I = imread('cameraman.tif');
%探测MSER特征区域
regions = detectMSERFeatures(I);
%用SURF特征向量描述MSER特征
[features, valid_points] = extractFeatures(I, regions);
%显示图像
figure; imshow(I);
%显示SURF特征，显示特征方向
hold on;
plot(valid_points,'showOrientation',true);

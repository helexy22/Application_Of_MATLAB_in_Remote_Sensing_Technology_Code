clear;

%提取SURF特征点
I = imread('cameraman.tif');
points = detectSURFFeatures(I);
figure;
imshow(I); 
hold on;
plot(points.selectStrongest(10));

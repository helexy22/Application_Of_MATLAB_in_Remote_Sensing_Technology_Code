clear;

%提取MSER特征点
I = imread('cameraman.tif');
regions = detectMSERFeatures(I);
figure;
imshow(I); 
hold on;
plot(regions);

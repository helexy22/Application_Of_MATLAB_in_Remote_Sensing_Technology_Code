clear;

%��ȡSURF������
I = imread('cameraman.tif');
points = detectSURFFeatures(I);
figure;
imshow(I); 
hold on;
plot(points.selectStrongest(10));

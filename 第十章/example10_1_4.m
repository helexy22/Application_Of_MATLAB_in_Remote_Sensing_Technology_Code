clear;

%��ȡMSER������
I = imread('cameraman.tif');
regions = detectMSERFeatures(I);
figure;
imshow(I); 
hold on;
plot(regions);

clear;
I =imread('blobs.png');
imwrite(I,'blobs.tif');
imshow('blobs.tif'); 

bw = imread('blobs.tif');
[x,y] = myBwboundaries(bw);
figure;imshow('blobs.tif');
hold on;plot(x,y,'r-');

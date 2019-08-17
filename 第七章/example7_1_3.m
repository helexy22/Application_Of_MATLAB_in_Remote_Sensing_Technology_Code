clear;
originalBW = imread('circles.png');  
se = strel('disk',11); 
erodedBW = imerode(originalBW,se);
imshow(originalBW), figure, imshow(erodedBW)

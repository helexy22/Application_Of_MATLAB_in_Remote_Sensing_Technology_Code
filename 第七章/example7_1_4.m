clear;
originalBW = imread('circles.png');  
se = strel('disk',10);
openBW = imopen(originalBW,se);
closeBW = imclose(originalBW,se);
figure, imshow(openBW)
figure, imshow(closeBW)

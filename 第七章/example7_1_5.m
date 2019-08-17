clear;
figure;
BW = imread('circles.png');
subplot(1,3,1);
imshow(BW);

BW2 = bwmorph(BW,'remove');
subplot(1,3,2);
imshow(BW2)

BW3 = bwmorph(BW,'skel',Inf);
subplot(1,3,3);
imshow(BW3)

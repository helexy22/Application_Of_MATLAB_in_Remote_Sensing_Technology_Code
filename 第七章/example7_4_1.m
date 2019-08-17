clear;
rgb = imread('peppers.png');
cform = makecform('srgb2lab');
lab = applycform(rgb,cform);
figure;imshow(rgb);figure;imshow(lab);

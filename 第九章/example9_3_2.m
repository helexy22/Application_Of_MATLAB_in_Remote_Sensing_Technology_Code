clear;

fun = @(block_struct) imresize(block_struct.data,0.5);
I = imread('pears.png');
I2 = blockproc(I,[100 100],fun);
figure;
imshow(I);
figure;
imshow(I2);

I1 = imresize(I,0.5);
isequal(I1,I2)

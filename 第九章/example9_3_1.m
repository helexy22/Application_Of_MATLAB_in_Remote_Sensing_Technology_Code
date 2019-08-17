clear;

I = imread('peppers.png');
fun = @(block_struct) block_struct.data(:,:,[2 1 3]);
blockproc(I,[200 200],fun,'Destination','grb_peppers.tif');
figure;
imshow('peppers.png');
figure;
imshow('grb_peppers.tif');

I1 = imread('grb_peppers.tif');
I2 = I(:,:,[2,1,3]);
isequal(I1,I2)

fun = @(block_struct) ...
   std2(block_struct.data) * ones(size(block_struct.data));
I2 = blockproc('moon.tif',[32 32],fun);
figure;
imshow('moon.tif');
figure;
imshow(I2,[]);


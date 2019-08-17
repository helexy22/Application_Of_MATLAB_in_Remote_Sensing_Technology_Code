clear;

path0 = 'pears.png';
path = 'pears.tif';
I = imread(path0);
imwrite(I,path);
I1 = imresize(I,0.5);
I2 = myBlockImresize(path,0.5);
isequal(I1,I2)

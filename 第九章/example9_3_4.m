clear;

path = 'moon.tif';
filterTemplate = ones(3)/9;

I = imread(path);
I1 = imfilter(I, filterTemplate);
I2 = myBlockImfilter(path,filterTemplate);
isequal(I1,I2)
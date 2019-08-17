function myImrotateUnitTest(path)
I = imread(path);
figure;
subplot(2,3,1);
imshow(I);
rI1 = myImrotate(I,30);
subplot(2,3,2);
imshow(rI1);
rI1 = myImrotate(I,-30);
subplot(2,3,3);
imshow(rI1);
rI2 = myImrotate(I,60,'nearest','crop');
subplot(2,3,4);
imshow(rI2);
rI3 = myImrotate(I,90,'bilinear','loose');
subplot(2,3,5);
imshow(rI3);
rI4 = myImrotate(I,180,'bicubic','loose');
subplot(2,3,6);
imshow(rI4);
end

% myImrotateUnitTest('moon.tif');
% myImrotateUnitTest('pears.png');
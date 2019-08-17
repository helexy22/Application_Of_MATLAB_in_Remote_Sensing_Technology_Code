clear;
I = imread('cameraman.tif');
subplot(2,2,1); 
imshow(I); title('Original Image');

H = fspecial('motion',20,45);
MotionBlur = imfilter(I,H,'replicate');
subplot(2,2,2); 
imshow(MotionBlur);title('Motion Blurred Image');

H = fspecial('disk',10);
blurred = imfilter(I,H,'replicate');
subplot(2,2,3); 
imshow(blurred); title('Blurred Image');

H = fspecial('unsharp');
sharpened = imfilter(I,H,'replicate');
subplot(2,2,4); 
imshow(sharpened); title('Sharpened Image');

figure;
processTypeNum = 3;
imagePath = 'cameraman.tif';
cTitleName = {
    'Original Image'; 'Motion Blurred Image';
    'Blurred Image'; 'Sharpened Image'
    };
cH = cell(processTypeNum,1);
cH{1} = fspecial('motion',20,45);
cH{2} = fspecial('disk',10);
cH{3} = fspecial('unsharp');
I = imread(imagePath);
for k = 1:processTypeNum+1
    if k == 1
        newI = I;
    else
        newI = imfilter(I,cH{k-1},'replicate');
    end
    subplot(2,2,k);
    imshow(newI); title(cTitleName{k});
end

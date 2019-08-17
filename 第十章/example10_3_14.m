clear;

I1 = rgb2gray(imread('scene_left.png'));%加载影像，并转换为灰度矩阵
I2 = rgb2gray(imread('scene_right.png'));
figure; imshowpair(I1,I2,'ColorChannels','red-cyan');%采用红、青颜色显示
title('Red-cyan composite view of the stereo images');

d = disparity(I1, I2, ...%计算水平核线影像的视差图
    'BlockSize', 35, ...
    'DisparityRange', [-6 10], ...
    'UniquenessThreshold', 0);
marker_idx = (d == -realmax('single'));%将标记为不可靠的视差值，
%采用可靠视差的最小值填充
d(marker_idx) = min(d(~marker_idx));

figure; %显示视差图
imshow(mat2gray(d));



clear;

I1 = rgb2gray(imread('scene_left.png'));%����Ӱ�񣬲�ת��Ϊ�ҶȾ���
I2 = rgb2gray(imread('scene_right.png'));
figure; imshowpair(I1,I2,'ColorChannels','red-cyan');%���ú졢����ɫ��ʾ
title('Red-cyan composite view of the stereo images');

d = disparity(I1, I2, ...%����ˮƽ����Ӱ����Ӳ�ͼ
    'BlockSize', 35, ...
    'DisparityRange', [-6 10], ...
    'UniquenessThreshold', 0);
marker_idx = (d == -realmax('single'));%�����Ϊ���ɿ����Ӳ�ֵ��
%���ÿɿ��Ӳ����Сֵ���
d(marker_idx) = min(d(~marker_idx));

figure; %��ʾ�Ӳ�ͼ
imshow(mat2gray(d));



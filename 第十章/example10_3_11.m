clear;

fixed  = imread('cameraman.tif');
theta = 20;%旋转参数
S = 2.3;%缩放参数
tform = affine2d([S.*cosd(theta) -S.*sind(theta) 0; %几何变形模型
S.*sind(theta) S.*cosd(theta) 0; 
0 0 1]);
moving = imwarp(fixed,tform);%影像几何变形和平移
moving = moving + uint8(10*rand(size(moving)));
figure, imshowpair(fixed,moving,'montage');

tformEstimate = imregcorr(moving,fixed);%估计影像几何变形
Rfixed = imref2d(size(fixed));

movingReg = imwarp(moving,tformEstimate,...%将变形后的影像按估计的几何变形纠正
'OutputView',Rfixed);

figure, imshowpair(fixed,movingReg,'montage');
figure, imshowpair(fixed,movingReg,'falsecolor');

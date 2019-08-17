clear;

fixed  = imread('cameraman.tif');
theta = 20;%��ת����
S = 2.3;%���Ų���
tform = affine2d([S.*cosd(theta) -S.*sind(theta) 0; %���α���ģ��
S.*sind(theta) S.*cosd(theta) 0; 
0 0 1]);
moving = imwarp(fixed,tform);%Ӱ�񼸺α��κ�ƽ��
moving = moving + uint8(10*rand(size(moving)));
figure, imshowpair(fixed,moving,'montage');

tformEstimate = imregcorr(moving,fixed);%����Ӱ�񼸺α���
Rfixed = imref2d(size(fixed));

movingReg = imwarp(moving,tformEstimate,...%�����κ��Ӱ�񰴹��Ƶļ��α��ξ���
'OutputView',Rfixed);

figure, imshowpair(fixed,movingReg,'montage');
figure, imshowpair(fixed,movingReg,'falsecolor');

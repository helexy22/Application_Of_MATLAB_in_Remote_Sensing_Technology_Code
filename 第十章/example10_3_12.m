clear;

fixed  = imread('pout.tif');
moving = imrotate(fixed, 5, 'bilinear', 'crop');
imshowpair(fixed, moving,'Scaling','joint');
[optimizer, metric] = imregconfig('monomodal')%����Ӧ�����Զ���׼�����Ͳ��

movingRegistered = imregister(moving,fixed,...%�Զ���׼����
    'rigid',optimizer, metric);
figure;
imshowpair(fixed, movingRegistered,'Scaling','joint');

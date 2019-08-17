clear;

fixed  = imread('pout.tif');
moving = imrotate(fixed, 5, 'bilinear', 'crop');
imshowpair(fixed, moving,'Scaling','joint');
[optimizer, metric] = imregconfig('monomodal')%自适应生成自动配准参数和测度

movingRegistered = imregister(moving,fixed,...%自动配准纠正
    'rigid',optimizer, metric);
figure;
imshowpair(fixed, movingRegistered,'Scaling','joint');

clear;

I = imread('pout.tif');%读图像
hcornerdet = vision.CornerDetector;%生成角点探测对象
points = step(hcornerdet, I);%将加点探测作用于图像，探测角点
[features, valid_points] = extractFeatures(I, points);%描述角点
figure; imshow(I); %显示影像
hold on;%显示所有点
plot(points(:,1),points(:,2),'.');
hold on;%显示有效的兴趣点
plot(valid_points(:,1), valid_points(:,2), 'y.')

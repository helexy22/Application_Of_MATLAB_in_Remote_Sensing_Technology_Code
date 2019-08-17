clear;

input = checkerboard;%棋盘图像
[h, w] = size(input);%获取图像高、宽
inImageCorners = [1 1; w 1; w h; 1 h];%计算原始图像四个角点
outImageCorners = [4 21; 21 121; 79 51; 26 6]; %原始图像四个角点对应的结果图像位置

hgte1 = vision.GeometricTransformEstimator(...%建立几何关系估计对象
'ExcludeOutliers', false);
tform = step(hgte1, inImageCorners, outImageCorners);%通过四个角点及对应点，
%估计几何关系
hgt = vision.GeometricTransformer;%建立几何变换对象
output = step(hgt, input, tform);%将计算的几何变换作用于原始图像，
%得到变换后结果图像
figure; %显示原始图像和结果图像
imshow(input); 
title('Original image');
figure; 
imshow(output); 
title('Transformed image');

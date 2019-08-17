clear;

hedge = vision.EdgeDetector;%创建边缘检测对象hedge，
%默认方式为Sobel边缘检测算子

hcsc = vision.ColorSpaceConverter(...%创建色彩空间转换对象hcsc，
'Conversion', 'RGB to intensity');%从RGB空间转换到单波段灰度空间

hidtypeconv =vision.ImageDataTypeConverter(...
'OutputDataType','single');%创建影像类型转换对象hidtypeconv，
%输出数据类型为single
img = step(hcsc, imread('peppers.png'));%对影像矩阵执行色彩空间转换
img1 = step(hidtypeconv, img);%对影像矩阵执行数据类型转换
edges = step(hedge, img1);%对影像矩阵执行边缘检测

figure;imshow(img1);%显示影像边缘检测结果
figure;imshow(edges);

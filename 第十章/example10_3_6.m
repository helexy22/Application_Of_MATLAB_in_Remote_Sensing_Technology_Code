clear;

Iin  = imread('cameraman.tif'); %读影像

figure;%显示影像
imshow(Iin);
title('Base image');

Iout = imresize(Iin, 0.7);%生成缩小0.7倍和逆时针旋转31度的影像
Iout = imrotate(Iout, 31);

figure; %显示缩小和旋转后的影像
imshow(Iout); 
title('Transformed image');

ptsIn = detectSURFFeatures(Iin);%对两幅图像，探测SURF特征点
ptsOut = detectSURFFeatures(Iout);
[featuresIn, validPtsIn] = extractFeatures(Iin, ptsIn);%描述SURF有效点
                                                                    %和对应的特征向量
[featuresOut, validPtsOut] = extractFeatures(Iout, ptsOut);

index_pairs = matchFeatures(featuresIn, featuresOut);%匹配特征向量

matchedPtsIn= validPtsIn(index_pairs(:,1));%检索匹配成功的特征点
matchedPtsOut = validPtsOut(index_pairs(:,2));

figure; %在图像上显示匹配的SURF特征点
showMatchedFeatures(Iin,Iout,matchedPtsIn,matchedPtsOut);
title('Matched SURF points, including outliers');

gte = vision.GeometricTransformEstimator;%建立几何转换关系估计对象，
%几何变换模型为'Nonreflective similarity'
gte.Transform = 'Nonreflective similarity';

[tform,inlierIdx]= step(gte,...%将几何转换关系估计作用于匹配点对，
matchedPtsOut.Location, matchedPtsIn.Location);%得到几何变换关系,
%和符合几何关系的线性索引

figure; %在图像上显示符合几何关系的匹配点对
showMatchedFeatures(Iin,Iout,...
matchedPtsIn(inlierIdx),matchedPtsOut(inlierIdx));
title('Matching inliers'); 
legend('inliersIn', 'inliersOut');

agt = vision.GeometricTransformer;%建立几何转换对象
Ir = step(agt, im2single(Iout), tform);%将计算出的几何变换，
%作用于变换后的影像，生成新的变换影像
figure; %显示新的变换影像，
%将变换后的影像恢复到变换前
imshow(Ir); 
title('Recovered image');

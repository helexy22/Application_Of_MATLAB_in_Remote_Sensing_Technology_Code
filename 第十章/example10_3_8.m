clear;

load stereoPointPairs%加载立体像对
[fLMedS, inliers] = estimateFundamentalMatrix(...%估计基础矩阵
    matched_points1,matched_points2,'NumTrials',4000);

% Show the inliers in the first image.
I1 = imread('viprectification_deskLeft.png');

figure; %显示在第一张影像中的符合条件的内部点
subplot(1,2,1);
imshow(I1);
title('Inliers and Epipolar Lines in First Image');
hold on;
plot(matched_points1(inliers,1), matched_points1(inliers,2), 'go')

% Compute the epipolar lines in the first image.
epiLines = epipolarLine(fLMedS', ...       %计算在第一张影像上的核线
    matched_points2(inliers, :));


% Compute the intersection points of the lines and the image border.
pts = lineToBorderPoints(epiLines, size(I1));%计算核线的相交点和影像边界

% Show the epipolar lines in the first image
line(pts(:, [1,3])', pts(:, [2,4])');%显示第一张影像的核线

% Show the inliers in the second image.
I2 = imread('viprectification_deskRight.png');
subplot(1,2,2);
imshow(I2); %显示第二张影像的符合条件的内部点
title('Inliers and Epipole Lines in Second Image');
hold on;
plot(matched_points2(inliers,1), matched_points2(inliers,2), 'go')

% Compute and show the epipolar lines in the second image.
epiLines = epipolarLine(fLMedS,...       %计算和显示在第二张影像上的核线
    matched_points1(inliers, :));
pts = lineToBorderPoints(epiLines, size(I2));
line(pts(:, [1,3])', pts(:, [2,4])');
truesize;

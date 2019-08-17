clear;

load stereoPointPairs%�����������
[fLMedS, inliers] = estimateFundamentalMatrix(...%���ƻ�������
    matched_points1,matched_points2,'NumTrials',4000);

% Show the inliers in the first image.
I1 = imread('viprectification_deskLeft.png');

figure; %��ʾ�ڵ�һ��Ӱ���еķ����������ڲ���
subplot(1,2,1);
imshow(I1);
title('Inliers and Epipolar Lines in First Image');
hold on;
plot(matched_points1(inliers,1), matched_points1(inliers,2), 'go')

% Compute the epipolar lines in the first image.
epiLines = epipolarLine(fLMedS', ...       %�����ڵ�һ��Ӱ���ϵĺ���
    matched_points2(inliers, :));


% Compute the intersection points of the lines and the image border.
pts = lineToBorderPoints(epiLines, size(I1));%������ߵ��ཻ���Ӱ��߽�

% Show the epipolar lines in the first image
line(pts(:, [1,3])', pts(:, [2,4])');%��ʾ��һ��Ӱ��ĺ���

% Show the inliers in the second image.
I2 = imread('viprectification_deskRight.png');
subplot(1,2,2);
imshow(I2); %��ʾ�ڶ���Ӱ��ķ����������ڲ���
title('Inliers and Epipole Lines in Second Image');
hold on;
plot(matched_points2(inliers,1), matched_points2(inliers,2), 'go')

% Compute and show the epipolar lines in the second image.
epiLines = epipolarLine(fLMedS,...       %�������ʾ�ڵڶ���Ӱ���ϵĺ���
    matched_points1(inliers, :));
pts = lineToBorderPoints(epiLines, size(I2));
line(pts(:, [1,3])', pts(:, [2,4])');
truesize;

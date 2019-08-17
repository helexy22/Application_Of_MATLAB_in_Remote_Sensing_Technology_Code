clear;

% Step 1: Read Stereo Image Pair
%������Ӱ���

I1 = im2double(rgb2gray(imread('yellowstone_left.png')));
I2 = im2double(rgb2gray(imread('yellowstone_right.png')));
imshowpair(I1, I2,'montage');
title('I1 (left); I2 (right)');

figure; imshowpair(I1,I2,'ColorChannels','red-cyan');
title('Composite Image (Red - Left Image, Cyan - Right Image)');

%Step 2: Collect Interest Points from Each Image
%�ռ�ÿ��Ӱ�����Ȥ��

blobs1 = detectSURFFeatures(I1, 'MetricThreshold', 2000);
blobs2 = detectSURFFeatures(I2, 'MetricThreshold', 2000);
figure; imshow(I1); hold on;
plot(blobs1.selectStrongest(30));
title('Thirty strongest SURF features in I1');

figure; imshow(I2); hold on;
plot(blobs2.selectStrongest(30));
title('Thirty strongest SURF features in I2');

% Step 3: Find Putative Point Correspondences
%�ҳ��ٶ����ڵ�ͬ����

[features1, validBlobs1] = extractFeatures(I1, blobs1);
[features2, validBlobs2] = extractFeatures(I2, blobs2);
indexPairs = matchFeatures(features1, features2, 'Metric', 'SAD', ...
    'MatchThreshold', 5);
matchedPoints1 = validBlobs1.Location(indexPairs(:,1),:);
matchedPoints2 = validBlobs2.Location(indexPairs(:,2),:);
figure;
showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
legend('Putatively matched points in I1', ...
    'Putatively matched points in I2');

% Step 4: Remove Outliers Using Epipolar Constraint
%���ú���Լ���Ƴ�����ƥ���

[fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(...
    matchedPoints1, matchedPoints2, 'Method', 'RANSAC', ...
    'NumTrials', 10000, 'DistanceThreshold', 0.1, 'Confidence', 99.99);
if status ~= 0 || ...
        isEpipoleInImage(fMatrix, size(I1)) || ...
        isEpipoleInImage(fMatrix', size(I2))
    error(['For the rectification to succeed, the images must ',
        'have enough corresponding points and the epipoles must be ',
        'outside the images.']);
end
inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);
figure;
showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
legend('Inlier points in I1', 'Inlier points in I2');

% Step 5: Rectify Images
%����Ӱ��

[t1, t2] = estimateUncalibratedRectification(fMatrix, ...
    inlierPoints1, inlierPoints2, size(I2));
geoTransformer = vision.GeometricTransformer(...
    'TransformMatrixSource', 'Input port');
I1Rect = step(geoTransformer, I1, t1);
I2Rect = step(geoTransformer, I2, t2);

% transform the points to visualize them together with the rectified
% images
%��ԭʼӰ��ĵ㾭�����α任��ת����������Ӱ����

pts1Rect = tformfwd(double(inlierPoints1), ...
    maketform('projective', double(t1)));
pts2Rect = tformfwd(double(inlierPoints2), ...
    maketform('projective', double(t2)));
figure;
showMatchedFeatures(I1Rect, I2Rect, pts1Rect, pts2Rect);
legend('Inlier points in rectified I1', ...
    'Inlier points in rectified I2');

Irectified = cvexTransformImagePair(I1, t1, I2, t2);
figure, imshow(Irectified);
title('Rectified Stereo Images (Red - Left Image, Cyan - Right Image)');

%Step 6: Generalize The Rectification Process
%һ�㻯��������
figure;
cvexRectifyImages('parkinglot_left.png', 'parkinglot_right.png');

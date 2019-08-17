clear;

% Step 1: Read Stereo Image Pair
%读立体影像对

I1 = im2double(rgb2gray(imread('yellowstone_left.png')));
I2 = im2double(rgb2gray(imread('yellowstone_right.png')));
imshowpair(I1, I2,'montage');
title('I1 (left); I2 (right)');

figure; imshowpair(I1,I2,'ColorChannels','red-cyan');
title('Composite Image (Red - Left Image, Cyan - Right Image)');

%Step 2: Collect Interest Points from Each Image
%收集每景影像的兴趣点

blobs1 = detectSURFFeatures(I1, 'MetricThreshold', 2000);
blobs2 = detectSURFFeatures(I2, 'MetricThreshold', 2000);
figure; imshow(I1); hold on;
plot(blobs1.selectStrongest(30));
title('Thirty strongest SURF features in I1');

figure; imshow(I2); hold on;
plot(blobs2.selectStrongest(30));
title('Thirty strongest SURF features in I2');

% Step 3: Find Putative Point Correspondences
%找出假定存在的同名点

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
%采用核线约束移除错误匹配点

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
%纠正影像

[t1, t2] = estimateUncalibratedRectification(fMatrix, ...
    inlierPoints1, inlierPoints2, size(I2));
geoTransformer = vision.GeometricTransformer(...
    'TransformMatrixSource', 'Input port');
I1Rect = step(geoTransformer, I1, t1);
I2Rect = step(geoTransformer, I2, t2);

% transform the points to visualize them together with the rectified
% images
%将原始影像的点经过几何变换，转换到纠正后影像上

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
%一般化纠正过程
figure;
cvexRectifyImages('parkinglot_left.png', 'parkinglot_right.png');

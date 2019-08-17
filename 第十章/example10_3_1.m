clear;

I1 = rgb2gray(imread('viprectification_deskLeft.png'));%��Ӱ��
%RGBͼ��ת��Ϊ�Ҷ�ͼ��
I2 = rgb2gray(imread('viprectification_deskRight.png'));

cornerDetector = vision.CornerDetector;%�ҵ��ǵ�
points1 = step(cornerDetector, I1);
points2 = step(cornerDetector, I2);

[features1, valid_points1] = extractFeatures(I1, points1);%��ȡ���򴰿���������
[features2, valid_points2] = extractFeatures(I2, points2);

index_pairs = matchFeatures(features1, features2);%ƥ����������
matched_points1 = valid_points1(index_pairs(:, 1), :);%����ƥ���������λ��
matched_points2 = valid_points2(index_pairs(:, 2), :);

figure; %��ʾƥ��ͬ���㣬�ں��Դ���ƥ����⣬���Գ�����ͼ���ƽ��Ч��
showMatchedFeatures(I1, I2, matched_points1, matched_points2);

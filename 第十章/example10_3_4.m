clear;

load stereoPointPairs;%��������ƥ��������
[fLMedS, inliers] = estimateFundamentalMatrix(...%��LMS���������ƻ�������
    matched_points1,matched_points2, 'NumTrials', 2000);%����������2000

I1 = imread('viprectification_deskLeft.png');%��ȡӰ��
I2 = imread('viprectification_deskRight.png');

figure;%��ʾԭʼƥ���
showMatchedFeatures(I1, I2, matched_points1, matched_points2,...
    'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');

figure;%��ʾ���ϼ��ι�ϵ��ƥ���
showMatchedFeatures(I1,I2,...
    matched_points1(inliers,:),matched_points2(inliers,:),...
    'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');

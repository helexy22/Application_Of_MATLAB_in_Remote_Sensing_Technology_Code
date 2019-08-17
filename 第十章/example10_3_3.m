clear;

load stereoPointPairs;%��������ƥ��������

fRANSAC = estimateFundamentalMatrix(...
    matched_points1, matched_points2,...
    'Method', 'RANSAC', ...%��RANSAC���������ƻ�������
    'NumTrials', 2000, ...                               %����������2000��
    'DistanceThreshold', 1e-4);%������ֵ1e-4��

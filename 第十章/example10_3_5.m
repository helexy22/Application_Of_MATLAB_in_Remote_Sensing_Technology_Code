clear;

%��������ƥ��������
load stereoPointPairs;
%ͨ����֪��ͬ�������������õ�ͬ�����
inlierPts1 = matched_points1(knownInliers, :);
inlierPts2 = matched_points2(knownInliers, :);

%����Normalized Eight-Point�����ƻ�������
fNorm8Point = estimateFundamentalMatrix(...
    inlierPts1, inlierPts2,'Method','Norm8Point')

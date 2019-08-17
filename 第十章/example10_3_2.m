clear;

I1 = imread('cameraman.tif');%��ͼ��
%������һ��˳ʱ����ת20�Ȳ��Ŵ�1.2����Ӱ��
I2 = imresize(imrotate(I1,-20), 1.2);

points1 = detectSURFFeatures(I1);%̽��SURF������
points2 = detectSURFFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);%��ȡ����SURF���������������
[f2, vpts2] = extractFeatures(I2, points2);

index_pairs = matchFeatures(f1, f2, 'Prenormalized', false);%ƥ��SURF��������

matched_pts1 = vpts1(index_pairs(:, 1));%����ƥ���������λ��
matched_pts2 = vpts2(index_pairs(:, 2));

figure; %��ʾƥ��������㣬�������еĴ���ƥ��㣬
%���Կ���ͼ�����ת������Ч��
showMatchedFeatures(I1,I2,matched_pts1,matched_pts2);
legend('matched points 1','matched points 2');

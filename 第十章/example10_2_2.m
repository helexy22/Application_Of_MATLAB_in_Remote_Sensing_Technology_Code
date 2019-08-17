clear;

I = imread('cameraman.tif');%��ͼ��
points = detectSURFFeatures(I);%̽��ͼ��SURF������
[features, valid_points] = extractFeatures(I, points);
%��ȡ����ͼ���SURF���������������
figure; imshow(I);%��ʾͼ��
hold on;%��ʾ��Ч����������ǿ��10�������㣬
%��ʾSURF��������
plot(valid_points.selectStrongest(10),'showOrientation',true);

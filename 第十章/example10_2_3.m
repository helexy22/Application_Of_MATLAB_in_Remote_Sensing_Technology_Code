clear;

%��ͼ��
I = imread('cameraman.tif');
%̽��MSER��������
regions = detectMSERFeatures(I);
%��SURF������������MSER����
[features, valid_points] = extractFeatures(I, regions);
%��ʾͼ��
figure; imshow(I);
%��ʾSURF��������ʾ��������
hold on;
plot(valid_points,'showOrientation',true);

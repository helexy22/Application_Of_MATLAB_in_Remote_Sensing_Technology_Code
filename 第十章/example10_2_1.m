clear;

I = imread('pout.tif');%��ͼ��
hcornerdet = vision.CornerDetector;%���ɽǵ�̽�����
points = step(hcornerdet, I);%���ӵ�̽��������ͼ��̽��ǵ�
[features, valid_points] = extractFeatures(I, points);%�����ǵ�
figure; imshow(I); %��ʾӰ��
hold on;%��ʾ���е�
plot(points(:,1),points(:,2),'.');
hold on;%��ʾ��Ч����Ȥ��
plot(valid_points(:,1), valid_points(:,2), 'y.')

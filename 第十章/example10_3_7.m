clear;

input = checkerboard;%����ͼ��
[h, w] = size(input);%��ȡͼ��ߡ���
inImageCorners = [1 1; w 1; w h; 1 h];%����ԭʼͼ���ĸ��ǵ�
outImageCorners = [4 21; 21 121; 79 51; 26 6]; %ԭʼͼ���ĸ��ǵ��Ӧ�Ľ��ͼ��λ��

hgte1 = vision.GeometricTransformEstimator(...%�������ι�ϵ���ƶ���
'ExcludeOutliers', false);
tform = step(hgte1, inImageCorners, outImageCorners);%ͨ���ĸ��ǵ㼰��Ӧ�㣬
%���Ƽ��ι�ϵ
hgt = vision.GeometricTransformer;%�������α任����
output = step(hgt, input, tform);%������ļ��α任������ԭʼͼ��
%�õ��任����ͼ��
figure; %��ʾԭʼͼ��ͽ��ͼ��
imshow(input); 
title('Original image');
figure; 
imshow(output); 
title('Transformed image');

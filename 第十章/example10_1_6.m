clear;

hedge = vision.EdgeDetector;%������Ե������hedge��
%Ĭ�Ϸ�ʽΪSobel��Ե�������

hcsc = vision.ColorSpaceConverter(...%����ɫ�ʿռ�ת������hcsc��
'Conversion', 'RGB to intensity');%��RGB�ռ�ת���������λҶȿռ�

hidtypeconv =vision.ImageDataTypeConverter(...
'OutputDataType','single');%����Ӱ������ת������hidtypeconv��
%�����������Ϊsingle
img = step(hcsc, imread('peppers.png'));%��Ӱ�����ִ��ɫ�ʿռ�ת��
img1 = step(hidtypeconv, img);%��Ӱ�����ִ����������ת��
edges = step(hedge, img1);%��Ӱ�����ִ�б�Ե���

figure;imshow(img1);%��ʾӰ���Ե�����
figure;imshow(edges);

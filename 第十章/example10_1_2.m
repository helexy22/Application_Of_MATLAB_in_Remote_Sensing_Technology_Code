clear;

I = im2single(imread('circuit.tif'));%��Ӱ��
cornerDetector = vision.CornerDetector(...%�����ǵ�̽�����
'Method','Local intensity comparison (Rosten & Drummond)');
pts = step(cornerDetector, I);%���ǵ�̽��������Ӱ��
color = [1 0 0];%������ͼ��ǲ������
drawMarkers = vision.MarkerInserter('Shape', 'Circle', ...
'BorderColor', 'Custom', 'CustomBorderColor', color);
J = repmat(I,[1 1 3]);%��Ӱ���ΪRGBӰ��
J = step(drawMarkers, J, pts);%����ǲ���������Ӱ��͵�
imshow(J); title ('Corners detected in a grayscale image');
%��ʾӰ��͵�

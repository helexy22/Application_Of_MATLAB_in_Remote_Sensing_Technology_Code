clear;

Iin  = imread('cameraman.tif'); %��Ӱ��

figure;%��ʾӰ��
imshow(Iin);
title('Base image');

Iout = imresize(Iin, 0.7);%������С0.7������ʱ����ת31�ȵ�Ӱ��
Iout = imrotate(Iout, 31);

figure; %��ʾ��С����ת���Ӱ��
imshow(Iout); 
title('Transformed image');

ptsIn = detectSURFFeatures(Iin);%������ͼ��̽��SURF������
ptsOut = detectSURFFeatures(Iout);
[featuresIn, validPtsIn] = extractFeatures(Iin, ptsIn);%����SURF��Ч��
                                                                    %�Ͷ�Ӧ����������
[featuresOut, validPtsOut] = extractFeatures(Iout, ptsOut);

index_pairs = matchFeatures(featuresIn, featuresOut);%ƥ����������

matchedPtsIn= validPtsIn(index_pairs(:,1));%����ƥ��ɹ���������
matchedPtsOut = validPtsOut(index_pairs(:,2));

figure; %��ͼ������ʾƥ���SURF������
showMatchedFeatures(Iin,Iout,matchedPtsIn,matchedPtsOut);
title('Matched SURF points, including outliers');

gte = vision.GeometricTransformEstimator;%��������ת����ϵ���ƶ���
%���α任ģ��Ϊ'Nonreflective similarity'
gte.Transform = 'Nonreflective similarity';

[tform,inlierIdx]= step(gte,...%������ת����ϵ����������ƥ���ԣ�
matchedPtsOut.Location, matchedPtsIn.Location);%�õ����α任��ϵ,
%�ͷ��ϼ��ι�ϵ����������

figure; %��ͼ������ʾ���ϼ��ι�ϵ��ƥ����
showMatchedFeatures(Iin,Iout,...
matchedPtsIn(inlierIdx),matchedPtsOut(inlierIdx));
title('Matching inliers'); 
legend('inliersIn', 'inliersOut');

agt = vision.GeometricTransformer;%��������ת������
Ir = step(agt, im2single(Iout), tform);%��������ļ��α任��
%�����ڱ任���Ӱ�������µı任Ӱ��
figure; %��ʾ�µı任Ӱ��
%���任���Ӱ��ָ����任ǰ
imshow(Ir); 
title('Recovered image');

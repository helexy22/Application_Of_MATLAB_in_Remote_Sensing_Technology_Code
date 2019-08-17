function [x,y] = myBwboundaries(bw)
count = 0;%ѭ������
%��������ͨ��ģ��
h = ones(3);
h([1;3;7;9]) = 0;
sz = size(bw);%Ӱ���С
%�������ؽǵ㵥ά����
x = 0.5 : 0.5 : sz(2)+0.5;
y = 0.5 : 0.5 : sz(1)+0.5;
%�ĸ����������һ�����أ����0
I = zeros(sz + 2);
I(2:end-1,2:end-1) = bw;
%��������������ؽǵ㵥ά����
x = x + 1;
y = y + 1;
%����ǵ����
[x,y] = meshgrid(x,y);
%�ڲ�ǵ�Ҷ�
bw = interp2(I,x,y);
%ȷ��Ӱ���Եλ��
bw = bw > 0 & bw < 1;
%�����ڲ��Ӱ���С
sz = size(bw);
%�洢��Ե��Ϣ��Ԫ������
cBoundary = cell(0,1);
%���������Ե����Ӱ��ȫΪ0ʱ��ֹͣ����
while any(bw(:))
    count = count + 1;%ѭ������
    %�������������ͨ��
    val = imfilter(double(bw),h);
    %�ҳ��������Ҷ���ͨ�ĵ���߼�����
    ind = val == 5;
    %����������Ե
    iCellBoundary = bwboundaries(bw,4);
    if count > 1%�ų�ѭ������һ�κ��γɵĵ���
        cLength = cellfun('size',iCellBoundary,1);
        ind = cLength == 2;
        iCellBoundary(ind) = [];
    end
    %�ϲ��������Ե
    cBoundary = cat(1,cBoundary,iCellBoundary);
    %�����Ե��������
    rc = cat(1,cBoundary{:});
    %�����Ե������Ӱ���е���������
    loc = sub2ind(sz, rc(:,1), rc(:,2));
    %����Ե���ر�Ϊ0
    bw(loc) = false;
    %���������Ҷ���ͨ�ĵ��Ϊ1����������Ե�������õ�
    bw(ind) = true;
end
%�ڱ߽�֮�����nan�ָ�
boundaryNum = length(cBoundary);
cRowCol = cell(boundaryNum * 2, 1);
cRowCol(1:2:end) = cBoundary;
cRowCol(2:2:end) = {nan(1,2)};
rc = cat(1,cRowCol{:});
%ȥ��ԭʼӰ������һ������������λ�õĵ�
ind = mod(rc,2) == 0;
ind = any(ind,2);
rc(ind,:) = [];
%���㵽ԭʼӰ������
rc = rc / 2;
x = rc(:,2);
y = rc(:,1);
end



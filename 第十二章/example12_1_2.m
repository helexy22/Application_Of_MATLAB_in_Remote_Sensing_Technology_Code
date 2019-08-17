clear;

%���ɶ��������
rng(0,'twister') % for reproducibility
X = rand(100,1);
Y = (abs(X - .55) > .4);
tree = fitctree(X,Y);
view(tree,'Mode','Graph')

%�޼����������
tree1 = prune(tree,'Level',1);
view(tree1,'Mode','Graph')

%���ö��������Ԥ�����
[~,score] = predict(tree1,X(1:10));
[score X(1:10,:)]

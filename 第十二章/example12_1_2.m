clear;

%生成二叉分类树
rng(0,'twister') % for reproducibility
X = rand(100,1);
Y = (abs(X - .55) > .4);
tree = fitctree(X,Y);
view(tree,'Mode','Graph')

%修剪二叉分类树
tree1 = prune(tree,'Level',1);
view(tree1,'Mode','Graph')

%利用二叉分类树预测类别
[~,score] = predict(tree1,X(1:10));
[score X(1:10,:)]

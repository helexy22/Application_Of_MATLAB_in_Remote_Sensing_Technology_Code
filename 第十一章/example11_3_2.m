clear;

%比较K-D树方式和穷举方式结果
load fisheriris
rng(1); % For reproducibility
n = size(meas,1);
idx = randsample(n,5);
X = meas(~ismember(1:n,idx),:); % Training data
Y = meas(idx,:);                % Query data
MdlKDT = KDTreeSearcher(X)

MdlES = ExhaustiveSearcher(X)

IdxKDT = knnsearch(MdlKDT,Y);
IdxES = knnsearch(MdlES,Y);

[IdxKDT IdxES]%这里说明两种方式的结果是一致的

%计算Y最近的至少两个点
load fisheriris
rng(1);                     % For reproducibility
n = size(meas,1);           % Sample size
qIdx = randsample(n,5);     % Indices of query data
X = meas(~ismember(1:n,qIdx),:);
Y = meas(qIdx,:);
Mdl = KDTreeSearcher(X,'Distance','minkowski')
Idx = knnsearch(Mdl,Y,'K',2)

%计算离Y最近的至少七个点
load fisheriris
rng(4);                     % For reproducibility
n = size(meas,1);           % Sample size
qIdx = randsample(n,5);     % Indices of query data
X = meas(~ismember(1:n,qIdx),:);
Y = meas(qIdx,:);
Mdl = KDTreeSearcher(X);
[Idx,D] = knnsearch(Mdl,Y,'K',7,'IncludeTies',true);

%计算索引中点编号数量
(cellfun('length',Idx))'

%距离Y中第一个点最近的包含了8个点，查看这些点的编号和距离
nn5 = Idx{1}
nn5d = D{1}

%计算范围查找K-D树方式和穷举方式
load fisheriris
rng(1); % For reproducibility
n = size(meas,1);
idx = randsample(n,5);
X = meas(~ismember(1:n,idx),3:4); % Training data
Y = meas(idx,3:4);                % Query data
MdlKDT = KDTreeSearcher(X)

MdlES = ExhaustiveSearcher(X)

r = 0.15; % Search radius
IdxKDT = rangesearch(MdlKDT,Y,r);
IdxES = rangesearch(MdlES,Y,r);

%判断结果是否一致
[IdxKDT IdxES]

(cellfun(@isequal,IdxKDT,IdxES))'

%显示最近邻聚类结果
setosaIdx = strcmp(species(~ismember(1:n,idx)),'setosa');
XSetosa = X(setosaIdx,:);
ySetosaIdx = strcmp(species(idx),'setosa');
YSetosa = Y(ySetosaIdx,:);
figure;
plot(XSetosa(:,1),XSetosa(:,2),'.k');
hold on;
plot(YSetosa(:,1),YSetosa(:,2),'*r');
for j = 1:sum(ySetosaIdx);
    c = YSetosa(j,:);
    circleFun = @(x1,x2)r^2 - (x1 - c(1)).^2 - (x2 - c(2)).^2;
    ezplot(circleFun,[c(1) + [-1 1]*r, c(2) + [-1 1]*r])
end
xlabel 'Petal length (cm)';
ylabel 'Petal width (cm)';
title 'Setosa Petal Measurements';
legend('Observations','Query Data','Search Radius');
axis equal
hold off

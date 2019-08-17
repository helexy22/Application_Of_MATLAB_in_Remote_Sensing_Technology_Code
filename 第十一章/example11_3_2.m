clear;

%�Ƚ�K-D����ʽ����ٷ�ʽ���
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

[IdxKDT IdxES]%����˵�����ַ�ʽ�Ľ����һ�µ�

%����Y���������������
load fisheriris
rng(1);                     % For reproducibility
n = size(meas,1);           % Sample size
qIdx = randsample(n,5);     % Indices of query data
X = meas(~ismember(1:n,qIdx),:);
Y = meas(qIdx,:);
Mdl = KDTreeSearcher(X,'Distance','minkowski')
Idx = knnsearch(Mdl,Y,'K',2)

%������Y����������߸���
load fisheriris
rng(4);                     % For reproducibility
n = size(meas,1);           % Sample size
qIdx = randsample(n,5);     % Indices of query data
X = meas(~ismember(1:n,qIdx),:);
Y = meas(qIdx,:);
Mdl = KDTreeSearcher(X);
[Idx,D] = knnsearch(Mdl,Y,'K',7,'IncludeTies',true);

%���������е�������
(cellfun('length',Idx))'

%����Y�е�һ��������İ�����8���㣬�鿴��Щ��ı�ź;���
nn5 = Idx{1}
nn5d = D{1}

%���㷶Χ����K-D����ʽ����ٷ�ʽ
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

%�жϽ���Ƿ�һ��
[IdxKDT IdxES]

(cellfun(@isequal,IdxKDT,IdxES))'

%��ʾ����ھ�����
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

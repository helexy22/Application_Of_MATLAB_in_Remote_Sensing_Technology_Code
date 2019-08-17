clear;

%���ɷ���������
load ionosphere
tc = fitctree(X,Y)

%����ģ���ӽڵ����
load ionosphere
rng(1); % For reproducibility
MdlDefault = fitctree(X,Y,'CrossVal','on');
numBranches = @(x)sum(x.IsBranch);
mdlDefaultNumSplits = cellfun(numBranches, MdlDefault.Trained);
figure;
histogram(mdlDefaultNumSplits)
view(MdlDefault.Trained{1},'Mode','graph')

Mdl7 = fitctree(X,Y,'MaxNumSplits',7,'CrossVal','on');
view(Mdl7.Trained{1},'Mode','graph')

classErrorDefault = kfoldLoss(MdlDefault)
classError7 = kfoldLoss(Mdl7)

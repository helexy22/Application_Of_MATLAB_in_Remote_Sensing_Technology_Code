clear;

load('fisheriris');
%计算训练集和测试集
CVO = cvpartition(species,'k',10);
%按测试集个数循环
err = zeros(CVO.NumTestSets,1);
for i = 1:CVO.NumTestSets
    %训练集索引
    trIdx = CVO.training(i);
    %测试集索引
    teIdx = CVO.test(i);
    %分类计算
    ytest = classify(meas(teIdx,:),meas(trIdx,:),...
        species(trIdx,:));
    %统计各个测试集的不一致个数
    err(i) = sum(~strcmp(ytest,species(teIdx)));
end
%计算所有测试集的错误比例
cvErr = sum(err)/sum(CVO.TestSize);

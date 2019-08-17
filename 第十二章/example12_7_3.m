clear;

load('fisheriris');
%����ѵ�����Ͳ��Լ�
CVO = cvpartition(species,'k',10);
%�����Լ�����ѭ��
err = zeros(CVO.NumTestSets,1);
for i = 1:CVO.NumTestSets
    %ѵ��������
    trIdx = CVO.training(i);
    %���Լ�����
    teIdx = CVO.test(i);
    %�������
    ytest = classify(meas(teIdx,:),meas(trIdx,:),...
        species(trIdx,:));
    %ͳ�Ƹ������Լ��Ĳ�һ�¸���
    err(i) = sum(~strcmp(ytest,species(teIdx)));
end
%�������в��Լ��Ĵ������
cvErr = sum(err)/sum(CVO.TestSize);

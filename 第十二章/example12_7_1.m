clear;

%ָ��100������������������������
c = cvpartition(100,'kfold',3)
%ָ����ʵ�����������л���
load('fisheriris');
CVO = cvpartition(species,'k',10);

try
    error('Here is error.');
catch exception
    msgString = getReport(exception);    %��ȡ������Ϣ����
    disp(msgString);                     %��ӡ������Ϣ
    a = 1;                               %�������öϵ�
end

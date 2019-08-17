try
    error('Here is error.');
catch exception
    msgString = getReport(exception);    %获取错误信息报告
    disp(msgString);                     %打印错误信息
    a = 1;                               %用于设置断点
end

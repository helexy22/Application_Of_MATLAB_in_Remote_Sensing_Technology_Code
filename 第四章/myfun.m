function Y = myfun(x)         %函数myfun记录在myfun.m文件中
Y(:,1) = 200*sin(x(:))./x(:);
Y(:,2) = x(:).^2;
end
function Y = myfun(x)         %����myfun��¼��myfun.m�ļ���
Y(:,1) = 200*sin(x(:))./x(:);
Y(:,2) = x(:).^2;
end
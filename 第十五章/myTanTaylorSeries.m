function cn = myTanTaylorSeries(x,n)
%tan(x) Taylor Series
xNum = length(x);
cn = nan(xNum,n+1);
an = mySinTaylorSeries(x, n);
bn = myCosTaylorSeries(x, n);
cn(:,1) = an(:,1) ./ bn(:,1);
for k = 1:n
    cn(:,k+1) = ...
        ( an(:,k+1) - sum( bn(:,2:k+1) .* cn(:,k:-1:1),2) ) ./ bn(:,1);
end
end

function y = mySinTaylorSeries(x,n)
%sin(x) Taylor级数
xNum = length(x);
y = zeros(xNum, n+1);
%奇数
iOrder = 1:2:n;
a = bsxfun(@power, -1, (iOrder - 1)/2 );
b = bsxfun(@power, x, iOrder);
c = factorial(iOrder);
b = bsxfun(@times, a, b);
y(:,iOrder+1) = bsxfun(@rdivide, b, c);
end

function y = myCosTaylorSeries(x,n)
%cos(x) Taylor级数
xNum = length(x);
y = zeros(xNum, n+1);
%偶数
iOrder = 0:2:n;
a = bsxfun(@power, -1, iOrder / 2);
b = bsxfun(@power, x, iOrder);
c = factorial(iOrder);
b = bsxfun(@times, a, b);
y(:,iOrder+1) = bsxfun(@rdivide, b, c);
end

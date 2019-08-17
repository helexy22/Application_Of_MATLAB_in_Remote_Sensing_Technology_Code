function vec = fseries3(a)
%FSERIES returns a vector of Taylor coefficients about a, through order 3.
%   f is defined in normal syntax below.
x = series(a,1,3);
y = cos(x)*sqrt(exp(-x*atan(x/2)+log(1+x^2)/(1+x^4)));
vec = double(y);
end
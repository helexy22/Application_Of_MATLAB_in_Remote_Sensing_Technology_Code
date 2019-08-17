clear;
addpath(fullfile(matlabroot,'extern','examples','shrlib'))
cd(fullfile(matlabroot,'extern','examples','shrlib'))
loadlibrary('shrlibsample')

str = 'This was a Mixed Case string';
calllib('shrlibsample','stringToUpper',str)

m = 1:12;
m = reshape(m,4,3)

dims = size(m)

calllib('shrlibsample','print2darray',m,4)

calllib('shrlibsample','print2darray',m',4)

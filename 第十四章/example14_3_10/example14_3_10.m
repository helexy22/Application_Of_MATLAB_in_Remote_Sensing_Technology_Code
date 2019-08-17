clear;

x0 = [0.3 0.4]                        % Starting guess
[x,resnorm] = lsqnonlin(@myfun,x0)    % Invoke optimizer

clear;

load fisheriris
PL = meas(:,3);
PW = meas(:,4);
h1 = gscatter(PL,PW,species,'krb','ov^',[],'off');
h1(1).LineWidth = 2;
h1(2).LineWidth = 2;
h1(3).LineWidth = 2;
legend('Setosa','Versicolor','Virginica','Location','best')
hold on

%线性分类器
X = [PL,PW];
cls = fitcdiscr(X,species);
%显示第2类和第3类的线性边界
%K是常数项，L是一次项
% First retrieve the coefficients for the linear
K = cls.Coeffs(2,3).Const;
% boundary between the second and third classes
% (versicolor and virginica).
L = cls.Coeffs(2,3).Linear;
% Plot the curve K + [x,y]*L  = 0.
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;

%显示第1类和第2类的线性边界
% Now, retrieve the coefficients for the linear boundary between the
% firstand second classes (setosa and versicolor).
K = cls.Coeffs(1,2).Const;
L = cls.Coeffs(1,2).Linear;
% Plot the curve K + [x1,x2]*L  = 0:
f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
h3 = ezplot(f,[.9 7.1 0 2.5]);
h3.Color = 'k';
h3.LineWidth = 2;
axis([.9 7.1 0 2.5])
xlabel('Petal Length')
ylabel('Petal Width')
title('{\bf Linear Classification with Fisher Training Data}')

%建立二次判别分析分类器
cqs = fitcdiscr(X,species,...
    'DiscrimType','quadratic');
%删除线性边界
% First, remove the linear boundaries from the plot.
delete(h2); delete(h3)
%显示第2类和第3类的边界
%K为常数项，L为一次项，Q为二次项
% Now, retrieve the coefficients for the quadratic boundary between
% the second and third classes (versicolor and virginica).
K = cqs.Coeffs(2,3).Const;
L = cqs.Coeffs(2,3).Linear;
Q = cqs.Coeffs(2,3).Quadratic;
%显示曲线，曲线方程如下：
% Plot the curve K + [x1,x2]*L + [x1,x2]*Q*[x1,x2]' = 0.
f = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 + ...
    (Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
h2 = ezplot(f,[.9 7.1 0 2.5]);
h2.Color = 'r';
h2.LineWidth = 2;
%显示第1类和第2类的边界
% Now, retrieve the coefficients for the quadratic boundary between
% thefirst and second classes (setosa and versicolor).
K = cqs.Coeffs(1,2).Const;
L = cqs.Coeffs(1,2).Linear;
Q = cqs.Coeffs(1,2).Quadratic;
% Plot the curve K + [x1,x2]*L + [x1,x2]*Q*[x1,x2]'=0:
% Plot the relevant portion of the curve.
f = @(x1,x2) K + L(1)*x1 + L(2)*x2 + Q(1,1)*x1.^2 + ...
    (Q(1,2)+Q(2,1))*x1.*x2 + Q(2,2)*x2.^2;
h3 = ezplot(f,[.9 7.1 0 1.02]);
h3.Color = 'k';
h3.LineWidth = 2;
axis([.9 7.1 0 2.5])
xlabel('Petal Length')
ylabel('Petal Width')
title('{\bf Quadratic Classification with Fisher Training Data}')
hold off

clear;

%采用训练的boost决策树分类，估计错误分类损失
load ionosphere;
ClassTreeEns = fitensemble(X,Y,'AdaBoostM1',100,'Tree');
rsLoss = resubLoss(ClassTreeEns,'Mode','Cumulative');
plot(rsLoss);
xlabel('Number of Learning Cycles');
ylabel('Resubstitution Loss');

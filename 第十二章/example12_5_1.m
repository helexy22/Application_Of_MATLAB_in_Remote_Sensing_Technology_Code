clear;

%加载数据，去掉分类标记为'setosa'类型的数据
load fisheriris
inds = ~strcmp(species,'setosa');
X = meas(inds,3:4);
y = species(inds);
SVMModel = fitcsvm(X,y)

classOrder = SVMModel.ClassNames

sv = SVMModel.SupportVectors;
%显示
figure
gscatter(X(:,1),X(:,2),y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('versicolor','virginica','Support Vector')
hold off

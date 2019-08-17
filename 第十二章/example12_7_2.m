clear;

c = cvpartition(100,'kfold',3)

cnew = repartition(c)

%函数repartition后，测试集索引发生变化
isequal(test(c,1),test(cnew,1))


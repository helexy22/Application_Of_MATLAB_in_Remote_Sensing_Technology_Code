clear;

c = cvpartition(100,'kfold',3)

cnew = repartition(c)

%����repartition�󣬲��Լ����������仯
isequal(test(c,1),test(cnew,1))


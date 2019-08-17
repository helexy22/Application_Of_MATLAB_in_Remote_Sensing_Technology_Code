clear all%清除之前的数据，读数据集

data = readtable('agaricus-lepiota.txt',...
    'ReadVariableNames',false);

data(1:5,1:10)%显示数据集中的5行10列的结果

labels = data(:,1);%将第一列是否有毒记录在labels中，并将是否有毒数字化
labels = categorical(labels{:,:});
data(:,1) = [];%删除数据集中的是否有毒

%设置22种描述的变量名称
VarNames = {'cap_shape' 'cap_surface' 'cap_color' 'bruises' 'odor' ...
    'gill_attachment' 'gill_spacing' 'gill_size' 'gill_color' ...
    'stalk_shape' 'stalk_root' 'stalk_surface_above_ring' ...
    'stalk_surface_below_ring' 'stalk_color_above_ring' ...
    'stalk_color_below_ring' 'veil_type' 'veil_color' 'ring_number' ....
    'ring_type' 'spore_print_color' 'population' 'habitat'};

data.Properties.VariableNames = VarNames;

sum(char(data{:,:}) == '?')%计算数据集中缺失描述数量

data(:,11) = [];%缺失的描述都来自11列的变量 (stalk_root)，所以移除数据集的11列

cats = categorical(data{:,:});%将所有描述都数字化
data = double(cats);
pdist2(data(1,:),data(2,:),'hamming')%海明距离计算第一种蘑菇和第二种蘑菇的差异

rng('default'); %For reproducibility%保证可重复性，设置默认随机种子

[IDX, C, SUMD, D, MIDX, INFO] = kmedoids(data,2,...%将数据集分类两类，
    'distance','hamming','replicates',3);             %距离测度选择海明距离，重复计算三次


%Initialize a vector for predicted labels.
%初始化一个预测向量
predLabels = labels;
%Assign group 1 to be poisonous.
%将分类索引IDX为1的设置为有毒
predLabels(IDX==1) = categorical({'p'});

%Assign group 2 to be edible.
%将分类索引IDX为2的设置为无毒
predLabels(IDX==2) = categorical({'e'});

confMatrix = confusionmat(labels,predLabels)%计算混淆矩阵

accuracy = ...
    (confMatrix(1,1)+confMatrix(2,2))/(sum(sum(confMatrix)))%计算总体预测正确率

precision = ...
    confMatrix(1,1) /(confMatrix(1,1)+confMatrix(2,1))%计算预测毒蘑菇的正确率


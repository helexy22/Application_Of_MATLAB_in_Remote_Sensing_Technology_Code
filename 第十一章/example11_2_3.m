clear all%���֮ǰ�����ݣ������ݼ�

data = readtable('agaricus-lepiota.txt',...
    'ReadVariableNames',false);

data(1:5,1:10)%��ʾ���ݼ��е�5��10�еĽ��

labels = data(:,1);%����һ���Ƿ��ж���¼��labels�У������Ƿ��ж����ֻ�
labels = categorical(labels{:,:});
data(:,1) = [];%ɾ�����ݼ��е��Ƿ��ж�

%����22�������ı�������
VarNames = {'cap_shape' 'cap_surface' 'cap_color' 'bruises' 'odor' ...
    'gill_attachment' 'gill_spacing' 'gill_size' 'gill_color' ...
    'stalk_shape' 'stalk_root' 'stalk_surface_above_ring' ...
    'stalk_surface_below_ring' 'stalk_color_above_ring' ...
    'stalk_color_below_ring' 'veil_type' 'veil_color' 'ring_number' ....
    'ring_type' 'spore_print_color' 'population' 'habitat'};

data.Properties.VariableNames = VarNames;

sum(char(data{:,:}) == '?')%�������ݼ���ȱʧ��������

data(:,11) = [];%ȱʧ������������11�еı��� (stalk_root)�������Ƴ����ݼ���11��

cats = categorical(data{:,:});%���������������ֻ�
data = double(cats);
pdist2(data(1,:),data(2,:),'hamming')%������������һ��Ģ���͵ڶ���Ģ���Ĳ���

rng('default'); %For reproducibility%��֤���ظ��ԣ�����Ĭ���������

[IDX, C, SUMD, D, MIDX, INFO] = kmedoids(data,2,...%�����ݼ��������࣬
    'distance','hamming','replicates',3);             %������ѡ�������룬�ظ���������


%Initialize a vector for predicted labels.
%��ʼ��һ��Ԥ������
predLabels = labels;
%Assign group 1 to be poisonous.
%����������IDXΪ1������Ϊ�ж�
predLabels(IDX==1) = categorical({'p'});

%Assign group 2 to be edible.
%����������IDXΪ2������Ϊ�޶�
predLabels(IDX==2) = categorical({'e'});

confMatrix = confusionmat(labels,predLabels)%�����������

accuracy = ...
    (confMatrix(1,1)+confMatrix(2,2))/(sum(sum(confMatrix)))%��������Ԥ����ȷ��

precision = ...
    confMatrix(1,1) /(confMatrix(1,1)+confMatrix(2,1))%����Ԥ�ⶾĢ������ȷ��


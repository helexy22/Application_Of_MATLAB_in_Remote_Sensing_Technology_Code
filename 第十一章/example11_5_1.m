clear;

%根据转换矩阵和输出矩阵，生成一个输出序列和状态序列
TRANS = [0.9 0.1; 0.05 0.95;]
EMIS = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6;...
    7/12, 1/12, 1/12, 1/12, 1/12, 1/12]

[seq,states] = hmmgenerate(1000,TRANS,EMIS);
%根据输出序列和状态序列，估计转换矩阵和输出矩阵
[TRANS_EST, EMIS_EST] = hmmestimate(seq, states)

%由输出序列、初始转换矩阵、初始输出矩阵，估计最可能的转换矩阵和输出矩阵
TRANS_GUESS = [0.85 0.15; 0.1 0.9];
EMIS_GUESS = [0.17 0.16 0.17 0.16 0.17 0.17;0.6 0.08 0.08 0.08 0.08 0.08];
[TRANS_EST2, EMIS_EST2] = hmmtrain(seq, TRANS_GUESS, EMIS_GUESS)

%根据输出序列、转换矩阵、输出矩阵，估计最可能的状态序列
likelystates = hmmviterbi(seq, TRANS, EMIS);
%根据输出矩阵、转换矩阵、输出矩阵，计算序列中输出的所有状态后验概率
pStates = hmmdecode(seq, TRANS, EMIS);

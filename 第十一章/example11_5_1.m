clear;

%����ת������������������һ��������к�״̬����
TRANS = [0.9 0.1; 0.05 0.95;]
EMIS = [1/6, 1/6, 1/6, 1/6, 1/6, 1/6;...
    7/12, 1/12, 1/12, 1/12, 1/12, 1/12]

[seq,states] = hmmgenerate(1000,TRANS,EMIS);
%����������к�״̬���У�����ת��������������
[TRANS_EST, EMIS_EST] = hmmestimate(seq, states)

%��������С���ʼת�����󡢳�ʼ������󣬹�������ܵ�ת��������������
TRANS_GUESS = [0.85 0.15; 0.1 0.9];
EMIS_GUESS = [0.17 0.16 0.17 0.16 0.17 0.17;0.6 0.08 0.08 0.08 0.08 0.08];
[TRANS_EST2, EMIS_EST2] = hmmtrain(seq, TRANS_GUESS, EMIS_GUESS)

%����������С�ת������������󣬹�������ܵ�״̬����
likelystates = hmmviterbi(seq, TRANS, EMIS);
%�����������ת������������󣬼������������������״̬�������
pStates = hmmdecode(seq, TRANS, EMIS);

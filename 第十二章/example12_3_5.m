clear;

n = 1000;                       % Sample size
rng(1);                         % For reproducibility
Y = randsample([-1 1],n,true);  % Random labels
tokenProbs = [0.2 0.3 0.1 0.15 0.25;...
    0.4 0.1 0.3 0.05 0.15];             % Token relative frequencies
tokensPerEmail = 20;                    % Fixed for convenience
X = zeros(n,5);
X(Y == 1,:) = mnrnd(tokensPerEmail,tokenProbs(1,:),sum(Y == 1));
X(Y == -1,:) = mnrnd(tokensPerEmail,tokenProbs(2,:),sum(Y == -1));
Mdl = fitcnb(X,Y,'Distribution','mn');
isGenRate = resubLoss(Mdl,'LossFun','ClassifErr')

newN = 500;
newY = randsample([-1 1],newN,true);
newX = zeros(newN,5);
newX(newY == 1,:) = mnrnd(tokensPerEmail,tokenProbs(1,:),...
    sum(newY == 1));
newX(newY == -1,:) = mnrnd(tokensPerEmail,tokenProbs(2,:),...
    sum(newY == -1));
oosGenRate = loss(Mdl,newX,newY)


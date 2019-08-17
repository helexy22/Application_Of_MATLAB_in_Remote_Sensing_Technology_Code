clear;

rng default;%for reproduecibility
X = [gallery('uniformdata',[10 3],12);...
gallery('uniformdata',[10 3],13)+1.2;...
gallery('uniformdata',[10 3],14)+2.5];
T = clusterdata(X,'maxclust',3); 
find(T'==2)

scatter3(X(:,1),X(:,2),X(:,3),100,T,'filled')

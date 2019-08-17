clear;

rng default;%for reproduecibility
X = [randn(100,2)+ones(100,2);...
    randn(100,2)-ones(100,2)];
opts = statset('Display','final');
[idx,C] = kmeans(X,2,...
    'Distance','cityblock',...
    'Replicates',5,...
    'Options',opts);

%显示分类后的点及类中心位置
plot(X(idx==1,1),X(idx==1,2),'rs','MarkerSize',5)
hold on
plot(X(idx==2,1),X(idx==2,2),'bo','MarkerSize',5)
plot(C(:,1),C(:,2),'kx',...
    'MarkerSize',10,'LineWidth',2)
legend('Cluster 1','Cluster 2',...
    'Location','NW')
title('Cluster Assignments and Centroids');
hold off

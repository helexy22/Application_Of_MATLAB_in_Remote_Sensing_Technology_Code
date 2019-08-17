clear;

load fisheriris
classes = unique(species)

%用PCA方法降低原始数据集中的维度，形成2维数据
[~,score] = pca(meas,'NumComponents',2);
GMModels = cell(3,1); % Preallocation
options = statset('MaxIter',1000);%最大迭代次数
rng(1); % For reproducibility

%分别采用1、2、3个高斯模型数，估计模型
for j = 1:3
    GMModels{j} = fitgmdist(score,j,'Options',options);
    fprintf('\n GM Mean for %i Component(s)\n',j)
    Mu = GMModels{j}.mu
end

%显示图形结果
figure;
for j = 1:3
    subplot(2,2,j)
    gscatter(score(:,1),score(:,2),species)
    h = gca;
    hold on
    %ezcontour(@(x1,x2)pdf(GMModels{j},[x1 x2]),...
    %    [h.XLim h.YLim],100)
    ezcontour(@(x1,x2) pdf(GMModels{j},[x1 x2]),get(h,{'XLim','YLim'}))
    title(sprintf('GM Model - %i Component(s)',j));
    xlabel('1st principal component');
    ylabel('2nd principal component');
    if(j ~= 3)
        legend off;
    end
    hold off
end
g = legend;
%g.Position = [0.7 0.25 0.1 0.1];
set(g,'Position',[0.7,0.25,0.1,0.1])

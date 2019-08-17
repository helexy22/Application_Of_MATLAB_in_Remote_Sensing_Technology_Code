clear;

%数据准备
load moore
X = [moore(:,1:5)];
y = moore(:,6);
%拟合非稳健模型和稳健模型
mdl = fitlm(X,y); % not robust
mdlr = fitlm(X,y,'RobustOpts','on');
%检查模型残差
subplot(1,2,1);plotResiduals(mdl,'probability')
subplot(1,2,2);plotResiduals(mdlr,'probability')

%移除标准模型以外的点
[~,outlier] = max(mdlr.Residuals.Raw);
mdlr.Robust.Weights(outlier)

median(mdlr.Robust.Weights)

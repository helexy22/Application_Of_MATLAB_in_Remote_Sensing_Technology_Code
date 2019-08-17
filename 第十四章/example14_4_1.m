clear;

%����׼��
load moore
X = [moore(:,1:5)];
y = moore(:,6);
%��Ϸ��Ƚ�ģ�ͺ��Ƚ�ģ��
mdl = fitlm(X,y); % not robust
mdlr = fitlm(X,y,'RobustOpts','on');
%���ģ�Ͳв�
subplot(1,2,1);plotResiduals(mdl,'probability')
subplot(1,2,2);plotResiduals(mdlr,'probability')

%�Ƴ���׼ģ������ĵ�
[~,outlier] = max(mdlr.Residuals.Raw);
mdlr.Robust.Weights(outlier)

median(mdlr.Robust.Weights)

clear;
[X,Y] = meshgrid(-2:0.75:2);
R = sqrt(X.^2 + Y.^2)+ eps;
V = sin(R)./(R);
[Xq,Yq] = meshgrid(-3:0.2:3);
Vq = interp2(X,Y,V,Xq,Yq,'cubic',0);

figure
surf(X,Y,V)
xlim([-4 4])
ylim([-4 4])
title('Original Sampling')

figure
surf(Xq,Yq,Vq)
title('Cubic Interpolation with Vq=0 Outside Domain of X and Y');

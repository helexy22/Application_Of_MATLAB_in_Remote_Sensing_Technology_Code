clear;
[X,Y] = meshgrid(-3:3);
V = peaks(X,Y);
[Xq,Yq] = meshgrid(-3:0.25:3);

figure
surf(X,Y,V)
title('Original Sampling');

Vq = interp2(X,Y,V,Xq,Yq);
figure
surf(Xq,Yq,Vq);
title('Linear Interpolation Using Finer Grid');

Vq = interp2(X,Y,V,Xq,Yq,'cubic');
figure
surf(Xq,Yq,Vq);
title('Cubic Interpolation Over Finer Grid');

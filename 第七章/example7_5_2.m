clear;
load clown
V = single(X(1:124,75:225));
figure;
subplot(1,2,1);
imagesc(V);
colormap gray
axis image
axis off
title('Original Image');

Vq = interp2(V,5);
subplot(1,2,2);
imagesc(Vq);
colormap gray
axis image
axis off
title('Linear Interpolation');

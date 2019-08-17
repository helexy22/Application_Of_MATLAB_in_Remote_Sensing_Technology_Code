clear;

I = im2single(imread('circuit.tif'));%读影像
cornerDetector = vision.CornerDetector(...%建立角点探测对象
'Method','Local intensity comparison (Rosten & Drummond)');
pts = step(cornerDetector, I);%将角点探测作用于影像
color = [1 0 0];%建立画图标记插入对象
drawMarkers = vision.MarkerInserter('Shape', 'Circle', ...
'BorderColor', 'Custom', 'CustomBorderColor', color);
J = repmat(I,[1 1 3]);%将影像变为RGB影像
J = step(drawMarkers, J, pts);%将标记插入作用于影像和点
imshow(J); title ('Corners detected in a grayscale image');
%显示影像和点

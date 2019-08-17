clear;
BW = imread('text.png');
s  = regionprops(BW, 'centroid');
centroids = cat(1, s.Centroid);
imshow(BW)
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off

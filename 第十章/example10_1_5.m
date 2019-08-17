clear;

I = imread('circuit.tif');
BW1 = edge(I,'prewitt');
BW2 = edge(I,'roberts');
BW3 = edge(I,'canny');
subplot(2,2,1); imshow(I); title('origin');
subplot(2,2,2); imshow(BW1); title('prewitt');
subplot(2,2,3); imshow(BW2); title('roberts');
subplot(2,2,4); imshow(BW3); title('canny');

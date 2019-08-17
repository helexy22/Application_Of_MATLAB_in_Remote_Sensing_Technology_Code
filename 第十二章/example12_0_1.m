clear;

%Step 1: Acquire Image
%读取影像
fabric = imread('fabric.png');
figure(1), imshow(fabric), title('fabric');

%Step 2: Calculate Sample Colors in L*a*b* Color Space for Each Region
%计算每个区域的L、a、b颜色空间的采样值，这些区域是事先选择好的区域
load regioncoordinates;
nColors = 6;
sample_regions = false([size(fabric,1) size(fabric,2) nColors]);
for count = 1:nColors
    sample_regions(:,:,count) = roipoly(fabric,...
        region_coordinates(:,1,count), region_coordinates(:,2,count));
end
imshow(sample_regions(:,:,2)),title('sample region for red');

cform = makecform('srgb2lab');
lab_fabric = applycform(fabric,cform);
a = lab_fabric(:,:,2);
b = lab_fabric(:,:,3);
color_markers = repmat(0, [nColors, 2]);
for count = 1:nColors
    color_markers(count,1) = mean2(a(sample_regions(:,:,count)));
    color_markers(count,2) = mean2(b(sample_regions(:,:,count)));
end
disp(sprintf('[%0.3f,%0.3f]',...
    color_markers(2,1),color_markers(2,2)));

%Step 3: Classify Each Pixel Using the Nearest Neighbor Rule
%将每个像素按最近邻方式分类
color_labels = 0:nColors-1;
a = double(a);
b = double(b);
distance = repmat(0,[size(a), nColors]);
for count = 1:nColors
    distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
        (b - color_markers(count,2)).^2 ).^0.5;
end
[value, label] = min(distance,[],3);
label = color_labels(label);
clear value distance;
%Step 4: Display Results of Nearest Neighbor Classification
%显示最近邻分类结果
rgb_label = repmat(label,[1 1 3]);
segmented_images = repmat(uint8(0),[size(fabric), nColors]);
for count = 1:nColors
    color = fabric;
    color(rgb_label ~= color_labels(count)) = 0;
    segmented_images(:,:,:,count) = color;
end
imshow(segmented_images(:,:,:,2)), title('red objects');

imshow(segmented_images(:,:,:,3)), title('green objects');

imshow(segmented_images(:,:,:,4)), title('purple objects');

imshow(segmented_images(:,:,:,5)), title('magenta objects');

imshow(segmented_images(:,:,:,6)), title('yellow objects');

%Step 5: Display 'a*' and 'b*' Values of the Labeled Colors.
%显示被标记颜色的值在a、b坐标系的位置
purple = [119/255 73/255 152/255];
plot_labels = {'k', 'r', 'g', purple, 'm', 'y'};
figure;
for count = 1:nColors
    plot(a(label==count-1),b(label==count-1),'.',...
        'MarkerEdgeColor',plot_labels{count},'MarkerFaceColor',...
        plot_labels{count});
    hold on;
end
title('Scatterplot of the segmented pixels in ''a*b*'' space');
xlabel('''a*'' values');
ylabel('''b*'' values');

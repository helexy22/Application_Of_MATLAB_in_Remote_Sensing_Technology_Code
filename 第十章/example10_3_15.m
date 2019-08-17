clear;

%第一步，读立体像对
%Step 1. Read Stereo Image Pair
hIdtc = vision.ImageDataTypeConverter;
hCsc = vision.ColorSpaceConverter('Conversion','RGB to intensity');
leftI3chan = step(hIdtc,imread('vipstereo_hallwayLeft.png'));
leftI = step(hCsc,leftI3chan);
rightI3chan = step(hIdtc,imread('vipstereo_hallwayRight.png'));
rightI = step(hCsc,rightI3chan);
figure(1), clf;
imshow(rightI3chan), title('Right image');

figure(2), clf;
imshowpair(rightI,leftI,'ColorChannels','red-cyan'), axis image;
title('Color composite (right=red, left=cyan)');

%第二步，简单的影像窗口匹配
%Step 2. Basic Block Matching
Dbasic = zeros(size(leftI), 'single');
disparityRange = 15;
% Selects (2*halfBlockSize+1)-by-(2*halfBlockSize+1) block.
halfBlockSize = 3;%选择窗口大小为2*halfBlockSize+1
blockSize = 2*halfBlockSize+1;

% Allocate space for all template matcher System objects.
tmats = cell(blockSize);%预分配匹配模板的对象空间

% Initialize progress bar
hWaitBar = waitbar(0, 'Performing basic block matching...');%初始化进度条
nRowsLeft = size(leftI, 1);
% Scan over all rows.
for m=1:nRowsLeft                    %遍历所有行
    % Set min/max row bounds for image block.
    minr = max(1,m-halfBlockSize);%设置影像窗口的最小最大的行边界
    maxr = min(nRowsLeft,m+halfBlockSize);
    
    % Scan over all columns.
    for n=1:size(leftI,2)%遍历所有列
        minc = max(1,n-halfBlockSize);
        maxc = min(size(leftI,2),n+halfBlockSize);
        
        % Compute disparity bounds.
        mind = max( -disparityRange, 1-minc );%计算所有视差边界
        maxd = min( disparityRange, size(leftI,2)-maxc );
        
        % Construct template and region of interest.
        template = rightI(minr:maxr,minc:maxc);%构建模板和兴趣区域
        templateCenter = floor((size(template)+1)/2);
        roi = [minc+templateCenter(2)+mind-1 ...
            minr+templateCenter(1)-1 ...
            maxd-mind+1 1];
        
        % Lookup proper TemplateMatcher object; create if empty.
        if isempty(tmats{size(template,1),size(template,2)})%查找模板匹配对象，
            %如果为空，则创建
            tmats{size(template,1),size(template,2)} = ...
                vision.TemplateMatcher('ROIInputPort',true);
        end
        thisTemplateMatcher= ...
            tmats{size(template,1),size(template,2)};
        
        % Run TemplateMatcher object.
        loc = step(thisTemplateMatcher, leftI, template, roi);%执行模板匹配对象
        Dbasic(m,n) = loc(1) - roi(1) + mind;
    end
    waitbar(m/nRowsLeft,hWaitBar);%设置进度条
end
close(hWaitBar);%关闭进度条
figure(3), clf;
imshow(Dbasic,[]), axis image, colormap('jet'), colorbar;
caxis([0 disparityRange]);
title('Depth map from basic block matching');

%Step 3. Sub-pixel Estimation
%第三步，子像素估计

DbasicSubpixel= zeros(size(leftI), 'single');
tmats = cell(2*halfBlockSize+1);
hWaitBar=waitbar(0,'Performing sub-pixel estimation...');
for m=1:nRowsLeft
    
    % Set min/max row bounds for image block.
    minr = max(1,m-halfBlockSize);%设置影像窗口的最小最大行边界
    maxr = min(nRowsLeft,m+halfBlockSize);
    
    % Scan over all columns.
    for n=1:size(leftI,2)%遍历所有列
        minc = max(1,n-halfBlockSize);
        maxc = min(size(leftI,2),n+halfBlockSize);
        
        % Compute disparity bounds.
        mind = max( -disparityRange, 1-minc );%计算视差边界
        maxd = min( disparityRange, size(leftI,2)-maxc );
        
        % Construct template and region of interest.
        template = rightI(minr:maxr,minc:maxc);%构建模板和兴趣区域
        
        templateCenter = floor((size(template)+1)/2);
        roi = [minc+templateCenter(2)+mind-1 ...
            minr+templateCenter(1)-1 ...
            maxd-mind+1 1];
        
        % Lookup proper TemplateMatcher object; create if empty.
        if isempty(tmats{size(template,1),size(template,2)})%查找模板匹配对象，
            %如果为空，则创建
            tmats{size(template,1),size(template,2)} = ...
                vision.TemplateMatcher('ROIInputPort',true,...
                'BestMatchNeighborhoodOutputPort',true);
        end
        thisTemplateMatcher = ...
            tmats{size(template,1),size(template,2)};
        
        % Run TemplateMatcher object.
        [loc,a2] = step(thisTemplateMatcher, leftI, template, roi);%进行模板匹配
        ix = single(loc(1) - roi(1) + mind);
        
        % Subpixel refinement of index.
        DbasicSubpixel(m,n) = ix - 0.5 * (a2(2,3) - a2(2,1)) ...%子像素位置估计
            / (a2(2,1) - 2*a2(2,2) + a2(2,3));
    end
    waitbar(m/nRowsLeft,hWaitBar);
end
close(hWaitBar);
figure(1), clf;
imshow(DbasicSubpixel,[]), axis image, colormap('jet'), colorbar;
caxis([0 disparityRange]);
title('Basic block matching with sub-pixel accuracy');


%Step 4. Dynamic Programming
%第四步，动态规划

Ddynamic = zeros(size(leftI), 'single');

% False infinity
finf = 1e3; %假的无穷大对应的值,为了使动态规划可以正常计算
disparityCost = finf*ones(size(leftI,2), 2*disparityRange + 1, ...
    'single');

% Penalty for disparity disagreement between pixels
disparityPenalty = 0.5;%设置相邻像素间视差不一致的惩罚值
hWaitBar = waitbar(0,'Using dynamic programming for smoothing...');

% Scan over all rows.
for m=1:nRowsLeft%遍历所有行
    disparityCost(:) = finf;
    
    % Set min/max row bounds for image block.
    minr = max(1,m-halfBlockSize);%设置影像窗口最小最大行边界
    maxr = min(nRowsLeft,m+halfBlockSize);
    
    % Scan over all columns.
    for n=1:size(leftI,2)%遍历所有列
        minc = max(1,n-halfBlockSize);
        maxc = min(size(leftI,2),n+halfBlockSize);
        
        % Compute disparity bounds.
        mind = max( -disparityRange, 1-minc );%计算视差边界
        maxd = min( disparityRange, size(leftI,2)-maxc );
        
        % Compute and save all matching costs.
        for d=mind:maxd%计算和保存匹配代价
            disparityCost(n, d + disparityRange + 1) = ...
                sum(sum(abs(leftI(minr:maxr,(minc:maxc)+d) ...
                - rightI(minr:maxr,minc:maxc))));
        end
    end
    
    % Process scan line disparity costs with dynamic programming.
    optimalIndices = zeros(size(disparityCost), 'single');%采用动态规划的方法，
    %处理每行的视差代价
    cp = disparityCost(end,:);
    for j=size(disparityCost,1)-1:-1:1
        
        % False infinity for this level
        cfinf = (size(disparityCost,1) - j + 1)*finf;%初始设置为伪无穷大值
        
        % Construct matrix for finding optimal move for each column
        % individually.
        [v,ix] = min([cfinf cfinf cp(1:end-4)+3*disparityPenalty;%单独建立每一列
            cfinf cp(1:end-3)+2*disparityPenalty;           %的最佳移动矩阵
            cp(1:end-2)+disparityPenalty;
            cp(2:end-1);
            cp(3:end)+disparityPenalty;
            cp(4:end)+2*disparityPenalty cfinf;
            cp(5:end)+3*disparityPenalty cfinf cfinf],[],1);
        cp = [cfinf disparityCost(j,2:end-1)+v cfinf];
        
        % Record optimal routes.
        optimalIndices(j,2:end-1) = (2:size(disparityCost,2)-1) +...
            (ix - 4);%记录最佳路径
    end
    
    % Recover optimal route.
    [~,ix] = min(cp);%记录最佳路径
    Ddynamic(m,1) = ix;
    for k=1:size(Ddynamic,2)-1
        Ddynamic(m,k+1) = optimalIndices(k, ...
            max(1, min(size(optimalIndices,2), ...
            round(Ddynamic(m,k)) ) ) );
    end
    waitbar(m/nRowsLeft, hWaitBar);
end
close(hWaitBar);
Ddynamic = Ddynamic - disparityRange - 1;
figure(3), clf;
imshow(Ddynamic,[]), axis image, colormap('jet'), colorbar;
caxis([0 disparityRange]);
title('Block matching with dynamic programming');

%Step 5. Image Pyramiding
%影像金字塔处理

% Construct a four-level pyramid
pyramids = cell(1,4);%建立四层金字塔
pyramids{1}.L = leftI;
pyramids{1}.R = rightI;
for i=2:length(pyramids)
    hPyr = vision.Pyramid('PyramidLevel',1);
    pyramids{i}.L = single(step(hPyr,pyramids{i-1}.L));
    pyramids{i}.R = single(step(hPyr,pyramids{i-1}.R));
end

% Declare original search radius as +/-4 disparities for every pixel.
%声明每个像素的视差原始搜索半径+/-4
smallRange = single(3);
disparityMin = repmat(-smallRange, size(pyramids{end}.L));
disparityMax = repmat( smallRange, size(pyramids{end}.L));

% Do telescoping search over pyramid levels.
for i=length(pyramids):-1:1%在金字塔水平伸缩搜索
    Dpyramid = vipstereo_blockmatch(pyramids{i}.L,pyramids{i}.R, ...
        disparityMin,disparityMax,...
        false,true,3,...
        true,... % Waitbar
        ['Performing level-',num2str(length(pyramids)-i+1),...
        ' pyramid block matching...']); %Waitbar title，进度条
    if i > 1
        % Scale disparity values for next level.
        hGsca = vision.GeometricScaler(...%下一级金字塔的视差需要乘以缩放系数
            'InterpolationMethod','Nearest neighbor',...
            'SizeMethod','Number of output rows and columns',...
            'Size',size(pyramids{i-1}.L));
        Dpyramid = 2*step(hGsca, Dpyramid);
        
        % Maintain search radius of +/-smallRange.
        disparityMin = Dpyramid - smallRange;%保持搜索半径+/-最小范围
        disparityMax = Dpyramid + smallRange;
    end
end
figure(3), clf;
imshow(Dpyramid,[]), colormap('jet'), colorbar, axis image;
caxis([0 disparityRange]);
title('Four-level pyramid block matching');

%Step 6. Combined Pyramiding and Dynamic Programming
%第六步，合并金字塔和动态规划结果

DpyramidDynamic = vipstereo_blockmatch_combined(leftI,rightI, ...
    'NumPyramids',3, 'DisparityRange',4, 'DynamicProgramming',true, ...
    'Waitbar', true, ...
    'WaitbarTitle', 'Performing combined pyramid and dynamic programming');
figure(3), clf;
imshow(DpyramidDynamic,[]), axis('image'), colorbar, colormap jet;
caxis([0 disparityRange]);
title('4-level pyramid with dynamic programming');


DdynamicSubpixel = vipstereo_blockmatch_combined(leftI,rightI, ...
    'NumPyramids',3, 'DisparityRange',4, 'DynamicProgramming',true, ...
    'Subpixel', true, ...
    'Waitbar', true, ...
    'WaitbarTitle', ['Performing combined pyramid and dynamic ',...
    'programming with sub-pixel estimation']);
figure(4), clf;
imshow(DdynamicSubpixel,[]), axis image, colormap('jet'), colorbar;
caxis([0 disparityRange]);
title('Pyramid with dynamic programming and sub-pixel accuracy');


%Step 7. Backprojection
%第七步，反投影

% Camera intrinsics matrix
%相机本质矩阵
K = [409.4433     0  204.1225
    0  416.0865  146.4133
    0         0    1.0000];

% Create a sub-sampled grid for backprojection.
%建立反投影的子像素采样格网
dec = 2;
[X,Y] = meshgrid(1:dec:size(leftI,2),1:dec:size(leftI,1));
P = K\[X(:)'; Y(:)'; ones(1,numel(X), 'single')];
Disp = max(0,DdynamicSubpixel(1:dec:size(leftI,1),1:dec:size(leftI,2)));
hMedF = vision.MedianFilter('NeighborhoodSize',[5 5]);

% Median filter to smooth out noise.
%中值滤波平滑噪声
Disp = step(hMedF,Disp);

% Derive conversion from disparity to depth with tie points:
%通过连接点将视差图转换到深度图
knownDs = [15   9   2]'; % Disparity values in pixels
knownZs = [4  4.5 6.8]';

% World z values in meters based on scene measurements.
%基于场景测量的世界坐标系Z值单位是米

% least squares
%最小二乘
ab = [1./knownDs ones(size(knownDs), 'single')] \ knownZs;

% Convert disparity to z (distance from camera)
%转换视差到Z（从相机到物体的距离）
ZZ = ab(1)./Disp(:)' + ab(2);

% Threshold to [0,8] meters.
%距离阈值范围设置为[0,8]米
ZZdisp = min(8,max(0, ZZ ));
Pd = bsxfun(@times,P,ZZ);

% Remove near points
%移除太近或太远的点
bad = Pd(3,:)>8 | Pd(3,:)<3;
Pd = Pd(:,~bad);

% Collect quantized colors for point display
%量化显示点的颜色
Colors = rightI3chan(1:dec:size(rightI,1),1:dec:size(rightI,2),:);
Colors = reshape(Colors,...
    [size(Colors,1)*size(Colors,2) size(Colors,3)]);
Colors = Colors(~bad,:);
cfac = 20;
C8 = round(cfac*Colors);
[U,I,J] = unique(C8,'rows');
C8 = C8/cfac;
figure(2), clf, hold on, axis equal;
for i=1:size(U,1)
    plot3(-Pd(1,J==i),-Pd(3,J==i),-Pd(2,J==i),...
        '.','Color',C8(I(i),:));
end

%设置视点
view(161,14), grid on;
xlabel('x (meters)'), ylabel('z (meters)'), zlabel('y (meters)');

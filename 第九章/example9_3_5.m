clear;

% Create the LanAdapter object associated with rio.lan.
input_adapter = LanAdapter('rio.lan');
% Select the visible R, G, and B bands.
input_adapter.SelectedBands = [3 2 1];
% Create a block function to simply return the block data unchanged.
identityFcn = @(block_struct) block_struct.data;
% Create the initial truecolor image.
truecolor = blockproc(input_adapter,[100 100],identityFcn);
% Display the un-enhanced results.
figure;
imshow(truecolor);
title('Truecolor Composite (Un-enhanced)');

adjustFcn = @(block_struct) imadjust(block_struct.data,...
    stretchlim(block_struct.data));
truecolor_enhanced = blockproc(input_adapter,[100 100],adjustFcn);
figure
imshow(truecolor_enhanced)
title('Truecolor Composite with Blockwise Contrast Stretch')

% Create the HistogramAccumulator object.
hist_obj = HistogramAccumulator();
% Split a sample image into 2 halves.
full_image = imread('liftingbody.png');
top_half = full_image(1:256,:);
bottom_half = full_image(257:end,:);
% Compute the histogram incrementally.
hist_obj.addToHistogram(top_half);
hist_obj.addToHistogram(bottom_half);
computed_histogram = hist_obj.Histogram;
% Compare against the results of IMHIST.
normal_histogram = imhist(full_image);
% Examine the results.  The histograms are numerically identical.
figure
subplot(1,2,1);
stem(computed_histogram,'Marker','none');
title('Incrementally Computed Histogram');
subplot(1,2,2);
stem(normal_histogram','Marker','none');
title('IMHIST Histogram');

% Create the HistogramAccumulator object.
hist_obj = HistogramAccumulator();
% Setup blockproc function handle
addToHistFcn = @(block_struct)...
hist_obj.addToHistogram(block_struct.data);
% Compute histogram of the red channel.  Notice that the addToHistFcn
% function handle does generate any output.  Since the function handle we
% are passing to blockproc does not return anything, blockproc will not
% return anything either.
input_adapter.SelectedBands = 3;
blockproc(input_adapter,[100 100],addToHistFcn);
red_hist = hist_obj.Histogram;
% Display results.
figure
stem(red_hist,'Marker','none');
title('Histogram of Red Band (Band 3)');

% Compute histogram for green channel.
hist_obj = HistogramAccumulator();
addToHistFcn = @(block_struct) hist_obj.addToHistogram(block_struct.data);
input_adapter.SelectedBands = 2;
blockproc(input_adapter,[100 100],addToHistFcn);
green_hist = hist_obj.Histogram;
% Compute histogram for blue channel.
hist_obj = HistogramAccumulator();
addToHistFcn = @(block_struct) hist_obj.addToHistogram(block_struct.data);
input_adapter.SelectedBands = 1;
blockproc(input_adapter,[100 100],addToHistFcn);
blue_hist = hist_obj.Histogram;

computeCDF = @(histogram) cumsum(histogram) / sum(histogram);
findLowerLimit = @(cdf) find(cdf > 0.01, 1, 'first');
findUpperLimit = @(cdf) find(cdf >= 0.99, 1, 'first');
red_cdf = computeCDF(red_hist);
red_limits(1) = findLowerLimit(red_cdf);
red_limits(2) = findUpperLimit(red_cdf);
green_cdf = computeCDF(green_hist);
green_limits(1) = findLowerLimit(green_cdf);
green_limits(2) = findUpperLimit(green_cdf);
blue_cdf = computeCDF(blue_hist);
blue_limits(1) = findLowerLimit(blue_cdf);
blue_limits(2) = findUpperLimit(blue_cdf);
% Prepare argument for IMADJUST.
rgb_limits = [red_limits' green_limits' blue_limits'];
% Scale to [0,1] range.
rgb_limits = (rgb_limits - 1) / (255);

adjustFcn = @(block_struct) imadjust(block_struct.data,rgb_limits);
% Select full RGB data.
input_adapter.SelectedBands = [3 2 1];
truecolor_enhanced = blockproc(input_adapter,[100 100],adjustFcn);
figure;
imshow(truecolor_enhanced)
title('Truecolor Composite with Corrected Contrast Stretch')

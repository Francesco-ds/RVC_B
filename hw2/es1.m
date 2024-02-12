I = imread('rice.png');
imshow(I);
se = strel('disk',15); % Create a disk-shaped structuring element with radius 15
background = imopen(I,se); % Perform morphological opening to obtain background
imshow(background);
I2 = I - background;
imshow(I2); % Display the resulting image after background subtraction
I3 = imadjust(I2);% Adjust the contrast of the image
imshow(I3);
bw = imbinarize(I3); % Convert the adjusted image to binary using Otsu's method
bw = bwareaopen(bw,50);% Remove small objects (less than 50 pixels)
imshow(bw);
cc = bwconncomp(bw,4);% Find connected components in the binary image
cc.NumObjects;% Get the number of connected components
grain = false(size(bw));
% Create a binary image to represent a single grain (example for the 50th grain)
grain(cc.PixelIdxList{50}) = true;
imshow(grain);
labeled = labelmatrix(cc);% Create a label matrix from the connected components
whos labeled;% Display information about the labeled matrix
RGB_label = label2rgb(labeled,'spring','c','shuffle');% Convert the label matrix to an RGB image with different colors for each object
imshow(RGB_label);
graindata = regionprops(cc,'basic');% Get region properties of connected components
grain_areas = [graindata.Area];% Extract the areas of grains
grain_areas(50);% Display the area of the 50th grain
[min_area, idx] = min(grain_areas);% Find the minimum area and its index
grain = false(size(bw));% Create a binary image to represent the grain with the minimum area
grain(cc.PixelIdxList{idx}) = true;
imshow(grain);
% Plot a histogram of grain areas
histogram(grain_areas);
title('Histogram of Rice Grain Area');
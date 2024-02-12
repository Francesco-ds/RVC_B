I = imread('eight.tif');
imshow(I);
bw = imbinarize(I);
imshow(bw);
bw = bwareaopen(bw,50);% Remove small objects (less than 50 pixels)
imshow(bw);
bw = 1-bw;% Invert the binary image
imshow(bw); % Display the inverted binary image
se = strel('disk',10); % Create a disk-shaped structuring element with radius 10
bw = imclose(bw,se);% Perform morphological closing to fill gaps in the objects
imshow(bw);% Display the binary image after morphological closing
cc = bwconncomp(bw,4);% Find connected components in the binary ima
cc.NumObjects; % Get the number of connected components
labeled = labelmatrix(cc); % Create a label matrix from the connected components
whos labeled;% Display information about the labeled matrix
RGB_label = label2rgb(labeled,'spring','c','shuffle'); % Convert the label matrix to an RGB image with different colors for each object
imshow(RGB_label); % Display the RGB labeled image
% coin = false(size(bw));
% coin(cc.PixelIdxList{4}) = true;
% imshow(coin)
coindata = regionprops(cc,'basic'); % Get region properties of connected components
coin_areas = [coindata.Area];% Extract the areas of coins
coin_areas(4); % Display the area of the 4th coin
[min_area, idx] = min(coin_areas); % Find the minimum area and its index
coin = false(size(bw)); % Create a binary image to represent the coin with the minimum area
coin(cc.PixelIdxList{idx}) = true; % Display the binary image representing the coin with the minimum area
imshow(coin);
% Plot a histogram of coin areas
histogram(coin_areas);
title('Histogram of Coins Area');
I = imread('fruit2.jpg');
imshow(I);
I = rgb2gray(I);
imshow(I);
bw = imbinarize(I);% Convert the grayscale image to binary using Otsu's method
imshow(bw);
bw = bwareaopen(bw,180);% Remove small objects (less than 180 pixels)
imshow(bw);

% Calculate region properties of connected components
stats = regionprops("table",bw,"Centroid","MajorAxisLength","MinorAxisLength","Eccentricity","Area");

% Extract centroids and eccentricity values
centroids = cat(1,stats.Centroid);
eccentricity = stats.Eccentricity;

% Identify and delete objects with area less than 100000 pixels
todelete= [];
for i = 1:size(stats,1)
    if(stats.Area(i) < 100000)
        todelete = [todelete i];
    end
end
   
% Remove objects with area less than 100000 pixels
for i = 1:size(todelete,1)
    stats(todelete(i),:) = [];
end

% Re-calculate centroids and eccentricity values after deletion
centroids = cat(1,stats.Centroid);
eccentricity = stats.Eccentricity;

% Initialize arrays to store apple and banana objects
apple = [];
banana = [];

% Classify objects as apple or banana based on eccentricity
for i = 1:size(stats,1)
    if(stats.Eccentricity(i)< 0.4)
        apple = [apple;stats(i,:)];
    else
        banana = [banana;stats(i,:)];
    end
end

% Define labels for apple and banana
applelabel = 'apple';
bananalabel = 'banana';

% Calculate diameters and radiuses for apples
diameters = mean([apple.MajorAxisLength apple.MinorAxisLength],2);
radiuses = diameters/2;

% Display the image with recognized objects
imshow(I)
title('Recognition of objects')
hold on

% Plot centroids of recognized objects
plot(centroids(:,1),centroids(:,2),'.', 'markerSize', 14, 'color', 'r');

% Plot circles around recognized apples
viscircles(centroids(2,:),radiuses,'Color','blue');

% Add labels for recognized objects
text(centroids(2,1),centroids(2,2),applelabel,'VerticalAlignment','bottom','HorizontalAlignment','left','Color','red','FontWeight','bold')
text(banana.Centroid(1,1),banana.Centroid(1,2),bananalabel,'VerticalAlignment','bottom','HorizontalAlignment','left','Color','red','FontWeight','bold')
hold off




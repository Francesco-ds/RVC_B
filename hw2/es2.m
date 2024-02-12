I = imread('mycoins.jpg');% Read the image
imshow(I);
I = rgb2gray(I);% Convert the image to grayscale
imshow(I);
bw = imbinarize(I);% Convert the grayscale image to binary using Otsu's method
imshow(bw);
bw = bwareaopen(bw,150);% Remove small objects (less than 150 pixels)
imshow(bw);

% Calculate region properties of connected components
stats = regionprops("table",bw,"Centroid","MajorAxisLength","MinorAxisLength","Eccentricity","Area");
% Extract centroids and eccentricity values
centroids = cat(1,stats.Centroid);
eccentricity = stats.Eccentricity;
% Initialize arrays to store circles and USB pen information
circles = [];
used = [];
usb = [];

% Extract circles based on eccentricity
for i = 1:size(stats,1)
    %must be 0,3, tried
    if(stats.Eccentricity(i)< 0.4)
        circles = [circles;stats(i,:)];
        used = [used i];
    end
end

% Extract USB pen based on eccentricity
for i = 1:size(stats,1)
    if (stats.Eccentricity(i) > 0.8)
        usb = [usb; stats(i,:)];
    end
end

% Extract information for circles
newcenters = [];
newArea = [];
usblabel = 'Usb pen';
coinlabel = strings(1,size(circles,1));
Areas = stats.Area;
centers = circles.Centroid;
clear i

% Retrieve centroid and area information for circles
for i = 1 : size(used,2)
    newcenters(i) = centers(used(i));
    newArea(i) = Areas(used(i));
end

% Classify coins as big or small based on area
for i=1:size(newArea,2)
    if(newArea(i)>280000)
        coinlabel(i) = 'Big coin';
    else
        coinlabel(i) = 'Small coin';
    end
end

% Remove USB pen objects with area less than 2000
for i = 1:size(usb,1)
    if  usb.Area(i)< 2000
        usb(i,:) = [];
    end
end

% Calculate diameters and radiuses for circles
diameters = mean([circles.MajorAxisLength circles.MinorAxisLength],2);
radiuses = diameters/2;
centroids(3,:) = []; % Remove manually

% Display the image with recognized objects 
imshow(I)
title('Recognition of objects')
hold on

% Plot centroids of recognized objects
plot(centroids(:,1),centroids(:,2),'.', 'markerSize', 14, 'color', 'r');

% Plot circles around recognized objects
viscircles(centers,radiuses,'Color','blue');
text(centers(:,1)+30,centers(:,2),coinlabel,'VerticalAlignment','bottom','HorizontalAlignment','left','Color','red','FontWeight','bold')

% Add labels for recognized objects
text(usb.Centroid(1,1),usb.Centroid(1,2),usblabel,'VerticalAlignment','bottom','HorizontalAlignment','left','Color','red','FontWeight','bold')
hold off

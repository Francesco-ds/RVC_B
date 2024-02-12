clear all;
clc;
close all;

% Call the function to get the point cloud and thresholded image
[nuvola,thresh_image] = getcloudpoint;

% Convert data to point cloud format
nuvola_right = pointCloud(nuvola);

% Fit a plane to the point cloud
model = pcfitplane(nuvola_right,10);
[x,y,z] = fitplanetocloud(model);

% Get contour points for fitting
[contour_cloud_done,centroid] = countourcloud(thresh_image);

% Plot the original point cloud and centroid
figure
plot3(nuvola(:,1), nuvola(:,2),nuvola(:,3), 'r.');
hold on
plot3(centroid(1),centroid(2),centroid(3), 'b*');
axis equal;
grid on;
hold off

% Perform line fitting with RANSAC
% We start with all data points, fit a line, and use outliers as new data
[line1,direction1,outlier1,flag1] = line_fitting_using_ransac(contour_cloud_done,4,200,40);
[line2,direction2,outlier2,flag2] = line_fitting_using_ransac(outlier1,4,200,40);
[line3,direction3,outlier3,flag3] = line_fitting_using_ransac(outlier2,4,200,40);
[line4,direction4,outlier4,flag4] = line_fitting_using_ransac(outlier3,4,200,40);

% Plot the results
data = contour_cloud_done;
close all;
figure
hold on
plot3(data(:,1),data(:,2),data(: ,3),'.','Color', 'r');
plot3(line1(:,1),line1(:,2),line1(: ,3),'.','Color', 'b');
plot3(line2(:,1),line2(:,2),line2(: ,3),'.','Color', 'm');
plot3(line3(:,1),line3(:,2),line3(: ,3),'.','Color', 'k');
plot3(line4(:,1),line4(:,2),line4(: ,3),'.','Color', 'y');
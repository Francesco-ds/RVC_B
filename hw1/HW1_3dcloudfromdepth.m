clear all
clc
%close all

depth = int32(imread('0000001-000000000000.png'));
rgb = int32(imread('0000001-000000000000.jpg'));

[row,column] = size(depth);

%Camera stats from the site
fu = 525;   % Focal length in the x-direction
fv = 525;   % Focal length in the y-direction
uo = 319.5; % Principal point coordinate in the x-direction
vo = 239.5; % Principal point coordinate in the y-direction

% Display the depth image
figure(1)
imagesc(depth);

% Initialize variables
cloud = [];
x = zeros(size(depth));
y = zeros(size(depth));

% Nested loops to iterate over each pixel in the depth image
for u = 1:row
    u %to know where we are
    for v = 1:column
        % Retrieve the depth value (z) of the current pixel
        z = depth(u,v);
           if z ~= 0
               % Calculate the 3D coordinates (x, y, z) of the point using the pinhole camera model
               x = -((z*(u-uo))/fu);
               y = -((z*(v-vo))/fv);
               % Store the 3D coordinates in the 'cloud' array
               cloud = [cloud;[x y -z]]; % Append the coordinates to 'cloud'
           end
    end
end

figure(2)
% Plot the 3D point cloud
plot3(cloud(:,1),cloud(:,2),cloud(:,3), 'r.');

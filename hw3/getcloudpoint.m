function [cloud,thresh_image] = getcloudpoint

    % Read the depth image
    depth = int32(imread('0000001-000000000000.png'));
    [row,column] = size(depth);
    
     % Parameters for camera calibration
    fu = 525;
    fv = 525;
    %switched
    uo = 319.5;
    vo = 239.5;

     % Display the depth image
    figure(1);
    colormap jet;
    imagesc(depth);

     % Initialize variables
    index = 0;
    x_cloud = zeros(row,column);
    y_cloud = zeros(row,column);
    mask =zeros(row,column);
    cloud = zeros(row*column,3); %only format accepted
    thresh_image=zeros(row,column);

    % Define upper and lower depth thresholds
    upper_threshold = 643;
    lower_threshold = 100;
    
    % Iterate over each pixel in the depth image
    for u = 1:row
        for v = 1:column

            % Calculate corresponding x and y coordinates in 3D space
            x_cloud(u,v) = -((double(depth(u,v))*(u - uo))/fu);
            y_cloud(u,v) = -((double(depth(u,v))*(v - vo))/fv);
            
            % Check if depth value is valid and within threshold
            if (depth(u,v) ~= 0 && depth(u,v) < upper_threshold && depth(u,v) > lower_threshold)

                mask(u,v) = 1;% Mark as valid pixel in the mask
                thresh_image(u,v) = depth(u,v);% Store depth value in the thresholded image
                index = index + 1;
                %this is how the function pointCloud wants its argument
                cloud(index,:) = [x_cloud(u,v) y_cloud(u,v) double(depth(u,v))]; % Store 3D point in the point cloud
            end

        end
    
    end
    
     % Trim excess zeros from the point cloud
    cloud = cloud(1:index,:);
    figure(3)
    plot3(cloud(:,1), cloud(:,2),cloud(:,3), 'r.');
    axis equal;
    grid on;
end
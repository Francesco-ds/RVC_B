% Pseudo code for the function line_fitting_using_ransac:
%   Possible outliers = all_data - 2 points (identification for line)
%   Get the direction
%   Point to line distance to check if an outlier can be an inlier
%   if inliers > min 
%       if size > best model
%           % Update best model


% This function fits a line to a set of 3D points using the RANSAC algorithm

% Input:
%   - data: The 3D point cloud data
%   - threshold: Threshold value to determine inliers
%   - iterations: Maximum number of RANSAC iterations
%   - min_inliers: Minimum number of inliers required for a valid line fit

function [line,direction,outliers,flag] = line_fitting_using_ransac(data,threshold,iterations,min_inliers)
    
    % Initialize variables
    inliers = [];
    index = 1;

    % Perform RANSAC iterations
    while index < iterations

        % Randomly select two points from the data
        random_index_point1 = randi(size(data,1));
        random_index_point2 = random_index_point1;
        
        % Ensure that two different points are selected
        while random_index_point1 == random_index_point2
            random_index_point2 = randi(size(data,1));
        end

        point1 = data(random_index_point1,:);
        point2 = data(random_index_point2,:);
        maybe_inliers = [point1;point2];
        maybe_outliers = data;
        maybe_maybe_outliers = [];

        % Remove selected points from the set of possible outliers
        if random_index_point1 > random_index_point2
            maybe_outliers(random_index_point1,:)=[];
            maybe_outliers(random_index_point2,:)=[];
    
        else
            maybe_outliers(random_index_point2,:)=[];
            maybe_outliers(random_index_point1,:)=[];
    
        end              

        % Compute distances of other points to the line defined by the two selected points
        for i = 1:size(maybe_outliers,1)
            point = maybe_outliers(i,:);
            distance = point_to_line_distance(point1,point2,point);
           
            % Classify point as inlier or outlier based on distance
            if distance < threshold
                maybe_inliers = [maybe_inliers;point];
            else
                maybe_maybe_outliers = [maybe_maybe_outliers;point];
            end
        
        
        end

        % Update inliers and outliers if the current set has more inliers
        if size(maybe_inliers,1) > min_inliers
        
            if size(maybe_inliers,1) > size(inliers,1)
                inliers = [];
                outliers = [];
                inliers = maybe_inliers;
                outliers = maybe_maybe_outliers;
            end
        end
    
        index = index + 1;
    end

    % Sort inliers and choose the longest axis to fit the line
    x_sort = sortrows(inliers,1);
    y_sort = sortrows(inliers,2);
    x_disp = abs(x_sort(1,1)-x_sort(end,1));
    y_disp = abs(y_sort(1,2)-y_sort(end,2));
    
    if x_disp > y_disp
    
        ordered_inliers = x_sort;
        flag = 0; % Flag indicating line orientation along x-axis
    
    else
        ordered_inliers = y_sort;
        flag = 1; % Flag indicating line orientation along y-axis
    end 
    
    % Compute starting and ending points for the line
    index_starting = ceil(size(ordered_inliers,1)/5);
    index_ending = 4*ceil(size(ordered_inliers,1)/5);
    line_template = -250:1:250;
    starting_point = ordered_inliers(index_starting,:);
    ending_point = ordered_inliers(index_ending,:);
    direction = (ending_point-starting_point)/norm(ending_point-starting_point);
    line = line_template'.*direction + starting_point; 

    % Plot the data, line, inliers, and starting point
    hold on
    plot3(data(:,1),data(:,2),data(: ,3),'.','Color', 'r');
    plot3(line(:,1),line(:,2),line(: ,3),'.','Color', 'b');
    plot3(inliers(:,1),inliers(:,2),inliers(: ,3),'.','Color', 'g');
    plot3(starting_point(:,1),starting_point(:,2),starting_point(: ,3),'x','Color', 'k');

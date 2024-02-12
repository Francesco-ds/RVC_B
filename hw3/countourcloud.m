function [cloud_countour_refined,centroid] = countourcloud(thresh_image)
    depth = imread('0000001-000000000000.png');
    imagesc(thresh_image);
    BW = imbinarize(thresh_image); % Binarize the thresholded image
    BW2 = bwareaopen(BW,50); % Remove small objects from the binary image
    imagesc(BW2);  % Display the processed binary image

    %Compute the 2D centroid of the binary image
    stats = regionprops('table',BW2,'Centroid');
    index_cen_x = stats.Centroid(1,1);
    index_cen_y = stats.Centroid(1,2);

    %Show the depth image with the centroid marked
    figure
    imshow(depth,[]);
    hold on
    plot(index_cen_x,index_cen_y,'ro', 'MarkerSize',10);
    

    % Camera parameter
    fu = 525;
    fv = 525;
    uo = 319.5;
    vo = 239.5;

    % Compute the 3D centroid
    centroid=[0;0;0];
    v = ceil(index_cen_x);
    u = ceil(index_cen_y);
    centroid(1) = -((double(thresh_image(u,v))*(u - uo))/fu);
    centroid(2) = -((double(thresh_image(u,v))*(v - vo))/fv);
    centroid(3) = double(thresh_image(ceil(index_cen_x),ceil(index_cen_y)));
   
    % Get contours of the binary image
    contours = imcontour(BW2);

    % Initialize variables
    cloud_countour = zeros(size(thresh_image));
    [row,column] = size(thresh_image);
        
    % Adjust contour dimensions and fit to image size
    for i = 2:1:size(contours,2)
        if(contours(1,i)<column && contours(2,i)<row)
        cloud_countour(ceil(contours(2,i)),ceil(contours(1,i))) = thresh_image(ceil(contours(2,i)),ceil(contours(1,i)));
        end
    end

    % Display the adjusted contour
    imagesc(cloud_countour);

    % Initialize variables for refining contours in 3D
    x_cloud = zeros(row,column);
    y_cloud = zeros(row,column);
    index = 0;
    cloud_countour_to_refine = zeros(row*column,3);
    mask =zeros(row,column);
    upper_threshold = 645;
    lower_threshold = 100;

    % Refine contours in 3D
    for u = 1:row
        for v = 1:column

            x_cloud(u,v) = -((double(cloud_countour(u,v))*(u - uo))/fu);
            y_cloud(u,v) = -((double(cloud_countour(u,v))*(v - vo))/fv);
            if (depth(u,v) ~= 0 && cloud_countour(u,v) < upper_threshold && cloud_countour(u,v) > lower_threshold)
                mask(u,v) = 1;
                index = index + 1;
                cloud_countour_to_refine(index,:) = [x_cloud(u,v) y_cloud(u,v) double(cloud_countour(u,v))];

            end
        end
    end

    % Remove excess zeros and return refined contour
    cloud_countour_refined = cloud_countour_to_refine(1:index,:);

    % Plot the refined contour in 3D
    figure
    plot3(cloud_countour_refined(:,1),cloud_countour_refined(:,2),cloud_countour_refined(:,3),'r.');
    hold on
    plot3(centroid(1),centroid(2),centroid(3),'b.');
    axis equal
    title("Contour in 3d")
    xlabel('x')
    ylabel('y')
    zlabel('z')
end
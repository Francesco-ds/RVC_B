function [x,y,z] = fitplanetocloud(model)

    % Extract plane parameters from the model
    a = model.Parameters(1);
    b = model.Parameters(2);
    c = model.Parameters(3);
    d = model.Parameters(4);
     
    % Generate a grid of x and y values within a specific range
    [x,y] = meshgrid(-200:1:150); % Adjust the range according to the point cloud

    % Calculate z values for the fitted plane using the plane equation
    % ax + by + cz + d = 0
    z = -1/c*(a*x + b*y + d);


end
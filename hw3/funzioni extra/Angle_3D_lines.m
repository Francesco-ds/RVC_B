% Define endpoints for Line 1
line1_endpoint1 = [0, 0, 1];
line1_endpoint2 = [2, 2, 1];

% Define endpoints for Line 2
line2_endpoint1 = [0, 0, 1];
line2_endpoint2 = [5, 0, 1];

% Create matrices for the lines
line1 = [line1_endpoint1; line1_endpoint2];
line2 = [line2_endpoint1; line2_endpoint2];

angle_between_lines(line1,line2)
function angle = angle_between_lines(line1, line2)
    % Normalize direction vectors
    direction1 = line1(2, :) - line1(1, :);
    direction1 = direction1 / norm(direction1);
    
    direction2 = line2(2, :) - line2(1, :);
    direction2 = direction2 / norm(direction2);
    
    % Compute dot product of direction vectors
    dot_product = dot(direction1, direction2);
    
    % Compute angle in radians using the dot product
    angle = acos(dot_product);
    
    % Convert angle to degrees
    angle = rad2deg(angle);
end


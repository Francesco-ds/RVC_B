function projection = project_point_on_plane(x, y, z, a, b, c, d)
    % Calculate the signed distance from the point to the plane
    distance = abs(a * x + b * y + c * z + d) / sqrt(a^2 + b^2 + c^2);
    
    % Calculate the projection of the point onto the plane
    projection_x = x - distance * a / sqrt(a^2 + b^2 + c^2);
    projection_y = y - distance * b / sqrt(a^2 + b^2 + c^2);
    projection_z = z - distance * c / sqrt(a^2 + b^2 + c^2);
    
    % Return the coordinates of the projected point
    projection = [projection_x, projection_y, projection_z];
end

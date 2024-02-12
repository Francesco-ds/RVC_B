%https://www.cuemath.com/geometry/distance-between-point-and-plane/
function distance = point_to_plane_distance (point,a,b,c,d)

    axo = a * point(1);
    byo = b * point(2);
    czo = c * point(3);
    % Compute the 3D point-to-plane distance
    num = abs(axo+byo+czo+d);
    den = sqrt(a^2 + b^2 + c^2);
    distance = num/den;
    
    % Display the result
    fprintf('Point: (%.2f, %.2f, %.2f)\n', point);
    fprintf('3D Point-to-Plane Distance: %.2f units\n', distance);
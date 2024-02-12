%https://it.mathworks.com/matlabcentral/answers/260593-distance-between-points-and-a-line-segment-in-3d
function distance_point_to_line = point_to_line_distance(point1,point2,point) 

    a = point1 - point2;
    b = point - point2;
    distance_point_to_line = sqrt(sum(cross(a,b,2).^2,2)) ./ sqrt(sum(a.^2,2));


end



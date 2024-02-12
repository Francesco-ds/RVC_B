%https://gamedev.stackexchange.com/questions/72528/how-can-i-project-a-3d-point-onto-a-3d-line


function projected_point_line = point_to_line(point1,point2,point)
    ap = point - point1;
    ab = point2 - point1;

    projected_point_line = point1 + dot(ap,ab)/dot(ab,ab) * ab;

end
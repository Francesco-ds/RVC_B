clear all;
clc
close all;

depth = int32(imread('0000001-000000000000.png'));
rgb = int32(imread('0000001-000000000000.jpg'));

% Initialize arrays and variables
triangles= [];
threshold = 10;
color = [];

%Camera stats from the site
fu = 525;           % Focal length in the x-direction
fv = 525;           % Focal length in the y-direction
uo = 319.5;         % Principal point coordinate in the x-direction
vo = 239.5;         % Principal point coordinate in the y-direction

% Define mapping for triangle vertices
%I start from top left, i am gonna check the bottom right triangle in both
%directions in this way
%[1 2 3] 
%[4 5 6]
%[7 8 9]
% Upper_triangle is 5 6 8, and lower_triangle is 6 8 9
% Map elements that shall be considered (depth > 0)
[row,column] = size(depth);
cloud = [];
count = 0;
to_cloud = zeros(row,column); % Matrix to map 2D indices to cloud indices

mask = zeros(row,column); % Initialize a mask for valid pixels
for u = 1:row
    for v = 1:column
        z = depth(u,v);
        if z ~= 0 
            x = -((z*(u-uo))/fu);
            y = -((z*(v-vo))/fv);
            cloud = [cloud;[x y -z]];   % Store 3D point
            count = count+1;
            to_cloud(u,v) = count;      % Map 2D indices to cloud indices
            mask(u,v) = 1;              % Mark pixel as valid
            color=[color; rgb(u,v)];    % Store RGB color
        end
    end
end

% Iterate over pixels to check every possible triangle without repetition
row
for u = 1:row-1
    u
    for v = 1:column-1
        z = depth(u,v);
        if z ~= 0
        
            A = to_cloud(u,v); %black square of the slides
            B = to_cloud(u,v+1); %right to A
            C = to_cloud(u+1,v); %under A
            D = to_cloud(u+1,v+1);%underright of A
            
            % B and C are common to both triangles, if one of the 2 is 0 we
            % dont have a triangle
            if B == 0 || C == 0
                continue % skip the iteration
            end
            
            % Check if the lower and/or upper triangle are valid
            % Use a threshold for robustness

            pointA = double(cloud(A,:));
            pointB = double(cloud(B,:));
            pointC = double(cloud(C,:));
            if D~= 0
                pointD = double(cloud(D,:));
            end

            AB = distance_3d_points(pointA,pointB);
            AC = distance_3d_points(pointA,pointC);
            BC = distance_3d_points(pointB,pointC);
            
            if D ~= 0
            BD = distance_3d_points(pointB,pointD);
            CD = distance_3d_points(pointC,pointD);
            end

            % Check if upper triangle is valid
            if AB < threshold || AC < threshold|| BC< threshold
                triangles = [triangles;[A B C]];

            end

            if D ~= 0 % Check if D is a valid index
            
                if BD < threshold || CD < threshold||BC < threshold
                    triangles = [triangles;[B C D]]; %store the triangle vertices
                end
            end
        
        end
    
    end

end

% Export the generated mesh along with color information to a PLY file
exportMeshToPly(cloud,triangles,color,'mesh_divano_hw2');
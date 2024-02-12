% Define different data points
x = [1.5, 2.7, 3.8, 4.2, 5.6];
y = [0.9, 1.2, 2.3, 3.5, 4.7];
z = [0.12, 0.25, 0.37, 0.48, 0.55];

%    We perform a least squares regression to fit a plane to the given data points.
%    This is done by solving a linear system using the backslash operator '\'.
%    The equation of a plane is given by 'z = ax + by + c', where 'a', 'b', and 'c'
%    are coefficients that define the plane. In matrix notation, this equation can
%    be represented as 'Ax = z', where 'A' is a matrix containing 'x', 'y', and a
%    column of ones, and 'x' is a vector of coefficients [a; b; c].
A = [x(:), y(:), ones(size(x(:)))];
B = A \ z(:);

% Create grid points for visualization
xv = linspace(min(x), max(x), 10)';
yv = linspace(min(y), max(y), 10)';
[X, Y] = meshgrid(xv, yv);

% Convert X and Y into column vectors
X_col = X(:);
Y_col = Y(:);

% Create a column vector of ones with the same size as X_col and Y_col
ones_vec = ones(size(X_col));

% Concatenate X_col, Y_col, and ones_vec horizontally to form a matrix
XY_ones_matrix = [X_col, Y_col, ones_vec];

% Perform matrix multiplication between the matrix and the coefficients B
Z_vector = XY_ones_matrix * B;

% Reshape the computed Z_vector into a 2D grid format
Z = reshape(Z_vector, numel(xv), []);
% Plot the original data points and the fitted plane
scatter3(x, y, z, 'filled')
hold on
mesh(X, Y, Z, 'FaceAlpha', 0.5)
hold off

% Set title to display the equation of the fitted plane
title(sprintf('Z = %f * X %f * Y %f', B))

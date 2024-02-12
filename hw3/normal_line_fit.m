% Point generation
n = 20;
a = randn(3,1);
b = randn(3,1);
t = rand(1,n);
points = a + b.*t;
points = points + 0.05*randn(size(points));

%line fit
centroid = mean(points,2);
deviation_vectors = points-centroid;
[U,S,~] = svd(deviation_vectors);
d = U(:,1); % principal direction
t = d'*deviation_vectors; % project deviation vectors on the principal directions
t1 = min(t);
t2 = max(t);
fitted_line = centroid + [t1,t2].*d; % size 3x2, endpoints of the line segment in 3d space
% Check
x = points(1,:);
y = points(2,:);
z = points(3,:);
xl = fitted_line(1,:);
yl = fitted_line(2,:);
zl = fitted_line(3,:);
close all

plot3(x,y,z,'o');
hold on
plot3(xl,yl,zl,'r');
axis equal
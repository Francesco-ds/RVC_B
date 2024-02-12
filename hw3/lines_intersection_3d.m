clear 
clc
syms s t % Define symbolic variables s and t

% p1 = [5,5,4];
% p2 = [10,10,6];
% p3 = [5,5,5];
% p4 = [10,10,3];

p1 = [4,0,4];
p2 = [0,0,0];
p3 = [0,0,4];
p4 = [4,0,0];

% Define the equations
eq1 = p1 + s*(p2 - p1);
eq2 = p3 + t*(p4 - p3);

% Set the equations equal to each other
eq = eq1 == eq2;

% Solve for s and t
[sol_s, sol_t] = solve(eq, [s, t]);

% Display the solutions
disp(sol_s);
disp(sol_t);

a = p1 + sol_s*(p2-p1);
vpa(a)
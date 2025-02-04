%% Inertia and Mass
m = 2.6; % [kg]
% Calculates the inertia tensor, later on, this will be provided by structures 
mass = 5.125;
height = 0.3;
depth = 0.1;
width = 0.1;

I_x = (1/12) * mass * (width ^ 2 + depth^2);
I_y = (1/12) * mass * (depth ^ 2 + height^2);
I_z = (1/12) * mass * (height ^ 2 + width^2);
I = diag([I_x, I_y, I_z]);

invI = inv(I);
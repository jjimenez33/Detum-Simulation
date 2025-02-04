clc;clear; close all

%%%% Simulation of a LEO CubeSat %%%%
disp('Simulation Started')

%% Get Planet Parameters
planet

%% Get mass and inertia properties
inertia

date = '01-Jan-2020';

%% Initial Conditions
tle = readmatrix("TLE.txt");
[r0, v0, coe] = TLE_RV(tle);

% Initial state
r = r0; % Position
v = v0; % Velocity
w = [0.08*0; -0.02*0; 0.03*0]; % Angular Velocity

phi0 = 0;
theta0 = 0;
psi0 = 0;
ptp0 = [phi0; theta0; psi0];
q = Euler2Quat(ptp0); % Quaternion

X = [r; v; w; q];


%% Time Window
semi_major_axis = coe(1);
period = 2*pi * sqrt(semi_major_axis^3 / mu);
number_of_orbits = 1;
dt = 1; % Time Step in Seconds
T_stop = number_of_orbits * period;
tt = 1:dt:T_stop; % Time Array

%% Initializing Storage for Position
num_steps = length(tt);

X_store = zeros(13, num_steps); % Store full state history
X_store(:,1) = X; % Initial state

position = zeros(3, num_steps); % Position storage
velocity = zeros(3, num_steps); % Velocity storage
angular_velocity = zeros(3, num_steps); % Angular Velocity storage
quaternion = zeros(4, num_steps); % Quaternion Velocity storage
eulerangles = zeros(3, num_steps); % Euler angle storage

% Magnetic Field in Inertial Frame storage
BxIout = zeros(1, num_steps); 
ByIout = BxIout;
BzIout = BxIout;

% Magnetic Field in Body Frame storage
BxBout = zeros(1, num_steps); 
ByBout = BxBout;
BzBout = BxBout;

% Measured Magnetic Field in Body Frame storage
BxB_measured = zeros(1, num_steps); 
ByB_measured = BxB_measured;
BzB_measured = BxB_measured;

% Measured Angular Velocity storage
wx_measured = zeros(1, num_steps);
wy_measured = wx_measured;
wz_measured = wx_measured;


%% Propagate Orbit
for i = 1:num_steps
    % Propagate state
    [X_out] = propagator(tt(i), X);
    X = X_out; % Update X for next step
    
    r = X(1:3);
    v = X(4:6);
    w = X(7:9);
    q = X(10:13);

    % Extract position and velocity
    position(:, i) = r; % Store position
    velocity(:, i) = v; % Store velocity
    angular_velocity(:, i) = w; % Store angular velocity
    quaternion(:, i) = q; % Store quaternion
    eulerangles(:, i) = quat2euler(q); 

    % Compute Magnetic Field in Inertial Frame
    [BxI, ByI, BzI] = get_mag_field_Earth(date, r);
    BxIout(i) = BxI;
    ByIout(i) = ByI;
    BzIout(i) = BzI;
    
    % Computes Magnetic Field in Body Frame
    BB = TIBquat(q)' * [BxI; ByI; BzI];
    % Convert to Tesla
    BB = BB*1e-9; % [T]

    BxBout(i) = BB(1);
    ByBout(i) = BB(2);
    BzBout(i) = BB(3);

    % Measured Magnetic Field in Body Frame
    [BB_measured, w_measured] = Sensor(BB, w);
    BxB_measured(i) = BB_measured(1);
    ByB_measured(i) = BB_measured(2);
    BzB_measured(i) = BB_measured(3);

    % Measured Angular Velocity
    wx_measured(i) = w_measured(1);
    wy_measured(i) = w_measured(1);
    wz_measured(i) = w_measured(3);
    %% Print Progress
    if mod(i, 60) == 0
        fprintf('Progress: %2.2f%%. \n', 100 * i / T_stop)
    end

    n = i + 1;
end 
disp('Simulation Complete')

%% Plots

%%% Orbit Plot %%%
% Make an Earth
fig = figure();
[X, Y, Z] = sphere;
X = X * Re;
Y = Y * Re;
Z = Z * Re;

% Earth Plot
surf(X, Y, Z, 'EdgeColor', 'none', 'FaceColor', 'cyan', 'FaceAlpha', 0.5)
hold on

% Orbit Plot
plot3(position(1, :), position(2, :), position(3, :), 'b-', 'LineWidth', 2)
axis equal
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
title('LEO CubeSat Orbit')
grid on



%%% Magnetic Field Plot %%%

% Plot Magnetic Field in Body Frame

fig2 = figure();
set(fig2, 'color', 'white')
plot(tt, BxBout, 'b-', 'LineWidth', 2)
hold on
grid on
plot(tt, ByBout, 'y-', 'LineWidth',2);
plot(tt, BzBout, 'g-', 'LineWidth', 2);
plot(tt, BxB_measured, 'b--', 'LineWidth', 2)
plot(tt, ByB_measured, 'y--', 'LineWidth',2);
plot(tt, BzB_measured, 'g--', 'LineWidth', 2);
xlabel('Time (sec)')
ylabel('Magnetic Field (T)')
legend('BBX', 'BBY', 'BBZ', 'BBX_Measured', 'BBY_Measured', 'BBZ_measured')



%%% Angular Velocity Plot %%%

fig4 = figure();
set(fig4, 'color', 'white')
plot(tt, angular_velocity(1, :), 'b-', 'LineWidth', 2)
hold on 
grid on
plot(tt, angular_velocity(2, :), 'y-', 'LineWidth',2);
plot(tt, angular_velocity(3, :), 'g-', 'LineWidth', 2);
plot(tt, wx_measured, 'b--', 'LineWidth', 2)
plot(tt, wy_measured, 'y--', 'LineWidth', 2)
plot(tt, wz_measured, 'g--', 'LineWidth', 2)
xlabel('Time [sec]')
ylabel('Angular Velocity [ rad/s]')
legend('WX', 'WY', 'WZ', 'WX_measured', 'WY_measured', 'WZ_measured')



%%% Euler Angle Plot %%%

% Plot EulerAngles
fig6 = figure();
set(fig6, 'color', 'white')

subplot(3,1,1)
grid on
plot(tt, eulerangles(1, :), 'b-', 'LineWidth', 2)
xlabel('Time [sec]')
ylabel('Euler Angles (phi) [rad]')

subplot(3,1,2)
plot(tt, eulerangles(2, :), 'g-', 'LineWidth',2);
xlabel('Time [sec]')
ylabel('Euler Angles (theta) [rad]')

subplot(3,1,3)
plot(tt, eulerangles(3, :), 'r-', 'LineWidth', 2);
xlabel('Time [sec]')
ylabel('Euler Angles (psi) [rad]')
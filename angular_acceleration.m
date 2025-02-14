function w_dot = angular_acceleration(w)
    inertia
    % Sums all the torques so angular acceleration can be found
    % torque = gravity_gradient_torque + magnetic_residue_pertubation(r, v, q) ...
    %     + drag_torque(r, v, q) + SRP_torque(t, r);
    torque = gettorques();

    % % Calculates the inertia tensor, later on, this will be provided by 
    % % structures 
    % mass = 5.125;
    % height = 0.3;
    % depth = 0.1;
    % width = 0.1;
    % 
    % I_x = (1/12) * mass * (width ^ 2 + depth^2);
    % I_y = (1/12) * mass * (width ^ 2 + height^2);
    % I_z = (1/12) * mass * (depth ^ 2 + height^2);
    % I = diag([I_x, I_y, I_z]);

    % torque = inertia tensor * angular acceleration
    H = I * w;
    w_dot = invI * (torque - cross(w, H));
end
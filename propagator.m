function X_out = propagator(t, X)
    
    dt = 1; 

    %% Split State Vector
    X1 = X(1:9);  % Position, Velocity, Angular Velocity (9x1)
    X2 = X(10:13); % Quaternion (4x1)

    %% RK4 Integration
        k1_X1 = func(t, X1);
        k1_X2 = quaternion_kinematics(X1(7:9), X2);

        k2_X1 = func(t + dt/2, X1 + k1_X1 * dt/2);
        k2_X2 = quaternion_kinematics(X1(7:9), X2 + k1_X2 * dt/2);

        k3_X1 = func(t + dt/2, X1 + k2_X1 * dt/2);
        k3_X2 = quaternion_kinematics(X1(7:9), X2 + k2_X2 * dt/2);

        k4_X1 = func(t + dt,   X1 + k3_X1 * dt);
        k4_X2 = quaternion_kinematics(X1(7:9), X2 + k3_X2 * dt);

    % Update state 
    X1_new = X1 + (dt/6) * (k1_X1 + 2 * k2_X1 + 2 * k3_X1 + k4_X1);
    X2_new = X2 + (dt/6) * (k1_X2 + 2*k2_X2 + 2*k3_X2 + k4_X2);

    % Recombine state vector
    X_out = [X1_new; X2_new]; 
   
end

function X_dot = func(t, X1)
inertia
    mu =  3.986004418e14;% mu - gravitational parameter of Earth in m3 s-2
    % Newtons universal gravitational law and F=ma. 
    r = X1(1:3);
    v = X1(4:6);
    w = X1(7:9);

    % Pertubations
    a_j2 = gravity_gradient_pertubation(r);
    a_d = drag_pertubation(r, v);
    a_SRP = SRP_pertubation(t, r);

    % Total Acceleration  
    a_p = a_j2 + a_d + a_SRP;                                       
    
    % Equation of Motion
    dr = v;
    dv = a_p - (mu / (norm(r))^3) * r; 
    dw = angular_acceleration(w);

    X_dot = [dr; dv; dw];
end

function dq = quaternion_kinematics(w, q)
    % Quaternion kinematics: dq/dt = 0.5 * Omega(w) * q
    Omega = 0.5 * [  0, -w(1), -w(2), -w(3);
                     w(1),  0,  w(3), -w(2);
                     w(2), -w(3),  0,  w(1);
                     w(3),  w(2), -w(1), 0];

    dq = Omega * q;
end


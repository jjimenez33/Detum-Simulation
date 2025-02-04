function a_d = drag_pertubation(r, v)

    % Given the state vector, output the acceleration due to drag

    % These are subject (and most likely) will change
    % constants for drag
    rho = 3.8e-12;                                                         % Air Desnity at 400 altitude (kg m3)
    Cd = 2.1;                                                              % Cd of a box
    area = 0.1 * 0.3;                                                      % surface of a 3U CubeSat (10 x 30 cm)
    mass = 5.125;                                                          % from Technical Budgets spreadsheet
    ballistic_coefficient = Cd * area / mass;                            
    
    % drag Pert
    atm_ang_vel = [0 0 72.9211e-6]';           % rad / s
    v_rel = v - cross(atm_ang_vel, r);

    a_d = -0.5 * rho * norm(v_rel) * ballistic_coefficient * v_rel;
end
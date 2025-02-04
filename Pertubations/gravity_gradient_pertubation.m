function a_gg = gravity_gradient_pertubation(r)
    
    % J2 Constant - Used for finding Pertubations due to gravity gradient
    J2_Constant = 0.001082; % 2nd zonal harmonic coefficient
    mu = 3.986004418e14;    % Gravitational parameter of Earth
    RE = 6.3781e6;          % Equatorial radius of the Earth [m]

    % Given the state vector, output the acceleration due to J2.
 
     % J2 Pert
     r2 = norm(r)^2;
     z2 = r(3)^2;
     
     tx = (r(1) / norm(r)) * (5 * (z2 / r2) - 1);
     ty = (r(2) / norm(r)) * (5 * (z2 / r2) - 1);
     tz = (r(3) / norm(r)) * (5 * (z2 / r2) - 3);
 
     a_gg = 1.5 * J2_Constant * mu * RE ^ 2 / r2^2;
     a_gg = a_gg * [tx ty tz]';
end
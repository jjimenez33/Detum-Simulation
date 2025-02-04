function B_i = get_local_B_field(r)
    RE = 6.378e6; % RE - Radius of Earth in meters
    % Given the position of the s/c, get the local magnetic field in the 
    % inertial and body frame. Code taken from the ADCS sim by Gavin Martin
    % https://github.com/gavincmartin/adcs-simulation
    r_mag = norm(r);

    % Mean magnetic field strength
    B_0 = 3.12e-5;

    % DCM from the ECI to Noth East Down frame
    DCM = DCM_I2NED(r);

    latitude = asin(r(3) / r_mag);

    % B_n is the local magnetic field in the NED frame
    B_n = B_0 * ((RE / r_mag) ^ 3) * [cos(latitude), 0, -2 * sin(latitude)]';

    % B_i is the local magnetic field in the inertial frame
    B_i = DCM' * B_n;
end

function r = get_sun_vector(t)

    % Given time since J2000, output the vector from the Earth to the Sun
    % time - [seconds]
    % sun_position - position of the sun in ECI [meters]

    % Algorithm 12.2 from Howard D. Curtis - Orbital Mechanics for Engineering Students
    % M - Mean anomaly, equation 12.109
    % L - mean solar longitude, equation 12.108
    % lambda - longitude, equation 12.107
    % epsilon - obliquity, equation 12.111
    % r - position vector, equations 12.100 & 12.112

    JD = time2JD(t);

    M = 357.529 + 0.98560023 * JD;
    L = 280.459 + 0.98564736 * JD;

    lambda = L + 1.915 * sin(M) + 0.020 * sin(2 * M);
    epsilon = 23.439 - 3.56e-7 * JD;

    r_hat = [cosd(lambda) sind(lambda) * cosd(epsilon) sind(lambda) * sind(epsilon)]';
    r_magn = 149597870691 * (1.00014 - 0.01671 * cosd(M) - 0.000140 * cos(2 * M));

    r = 10e3 * r_magn * r_hat;
end
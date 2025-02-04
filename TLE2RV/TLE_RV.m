function [r, v, coe] = TLE_RV(tle)

    %% Given a TLE, gives the COEs as a column vector

    % constants and parameters
    mu = 3.986004418e14;          % Standard gravitational parameter mu = GM, [m^3/s^2]
    d2r = pi / 180;                                    % Constant to convert [degrees] to [radians]
    rev2r = 2 * pi / (24 * 60^2);                      % Constant to convet [rev/day] to [radians/sec]

    % other TLE info
    mean_motion = tle(2, 8) * rev2r;                   % converted from [rev/day] to [radian/sec]

    % Extracting COEs
    semi_major_axis = (mu / mean_motion ^ 2)^(1/3);  % [meters]
    eccentricity = tle(2,5);                                              % [dimensionless]
    inclination = d2r * tle(2, 3);                                        % [radians]
    RAAND = d2r * tle(2, 4);                                              % [radians]
    argument_of_periapsis = d2r * tle(2, 6);                              % [radians]
    mean_anomaly = tle(2,7) * d2r;                                        % [radians]

    coe = [semi_major_axis, eccentricity, inclination, RAAND, argument_of_periapsis, mean_anomaly]';

    


    %% Obtaining the state vector [r; v] given COEs
    % COEs are: semi-major axis, eccentricity, inclination, RAAND, argument of periapsis, and mean anomaly

    % constants and parameters
    semi_major_axis = coe(1);
    eccentricity = coe(2);
    inclination = coe(3);
    RAAND = coe(4);
    argument_of_periapsis = coe(5);
    mean_anomaly = coe(6);

    mean_motion = 1 / (semi_major_axis ^ 3 / mu)^0.5;

    % newtons method setup
    E = 0;
    previous_E = E;

    current_error = inf;
    acceptable_error = 10^-6;

    % newtons method
    while current_error > acceptable_error

        f_approx_E = E - eccentricity  * sin(E) - mean_anomaly;                              
        f_deriv_appox_E = 1 - eccentricity * cos(E);                    

        E = previous_E - f_approx_E / f_deriv_appox_E;

        current_error = abs(E - previous_E);
        previous_E = E;
    end
    eccentric_anomaly = E;

    % solves for intial state vectors
    r_magn = semi_major_axis * (1 - eccentricity * cos(eccentric_anomaly));              % magnitude of r in meters

    x = semi_major_axis * (cos(eccentric_anomaly) - eccentricity);                       % x cordinate in the orbit plane
    y = semi_major_axis * (1 - eccentricity^2)^(1/2) * sin(eccentric_anomaly);           % y cordinate in the orbit plane

    constant = mean_motion * semi_major_axis^2 / r_magn;                                 % that one constant in both equations (idk what it is called either)
    x_dot = -constant * sin(eccentric_anomaly);                                          % x-comp. of vel in the orbit plane
    y_dot = constant * (1 - eccentricity^2)^(1/2) * cos(eccentric_anomaly);              % y-comp. of vel in the orbit plane

    % 3 - 1 - 3 euler rotation matrixes
    A_1 = [cos(RAAND) sin(RAAND) 0 ; -sin(RAAND) cos(RAAND) 0 ; 0 0 1];
    A_2 = [1 0 0 ; 0 cos(inclination) sin(inclination) ; 0 -sin(inclination) cos(inclination)];
    A_3 = [cos(argument_of_periapsis) sin(argument_of_periapsis) 0 ; -sin(argument_of_periapsis) cos(argument_of_periapsis) 0 ; 0 0 1];
    A = (A_3 * A_2 * A_1)';

    % initial state vectors
    r = A * [x y 0]';
    v = A * [x_dot y_dot 0]';
end

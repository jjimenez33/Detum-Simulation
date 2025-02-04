function a_SRP = SRP_pertubation(t, r)

    % Given time and the state vector, output the pertubation from SRP
    % The radiation pressure coefficent C_r is assumed to be 2 (Not real value)
    RE = 6.378e6;

    % SRP Pert
    sun_vector = get_sun_vector(t);

    % Following algorithmn determines if the Earth is inbetween the sun and the S/C. 
    % Taken from algorithmn 12.3 of Howard D. Curtis - Orbital Mechanics for Engineering Students 3rd
    theta = acos(dot(r, sun_vector) / (norm(r) * norm(sun_vector)));
    theta1 = acos(0.001 * RE / norm(r));
    theta2 = acos(0.001 * RE / norm(sun_vector));

    if (theta1 + theta2 > theta)

        % Radiation Pressure Coefficent,
        % between 1 and 2. 
        % 1 is black body and momentum is absord, 
        % 2 is photon is reflected and more force

        S = 1367;
        c = 9e8;
        C_r = 2; 
        A = 0.1 * 0.3;

        % Vector between the s/c and sun in ECI. 
        u = sun_vector - r;

        a_SRP = - (S / c)  * C_r * A * (u / norm(u));
    else
        a_SRP = 0;
    end
end
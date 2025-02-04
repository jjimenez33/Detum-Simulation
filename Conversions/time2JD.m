function JD = time2JD(t)

    % Given the current time of the simulation, outputs the time in JD
    % Assumes intial JD time is 2460676.5 (jan. 1 2025)

    JD_0 = 2460676.5;
    JD = JD_0 + t * s2d;
end
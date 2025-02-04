function [BB, w] = Sensor(BB, w)

for i = 1:3
    % Get Sensor Paramaters
    sensor_params
    % Pollute the data
    BB(i) = BB(i) + MagFieldBias + MagFieldNoise;
    w(i) = w(i) + AngFieldBias + AngFieldNoise;
end

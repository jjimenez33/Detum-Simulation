%% Bias and Noise
MagscaleBias = (4e-7); % [T]
MagFieldBias = MagscaleBias*(2*rand()-1); 

MagscaleNoise = (1e-5); % [T]
MagFieldNoise = MagscaleNoise*(2*rand()-1);

AngscaleBias = 0.01; % rad/s
AngFieldBias = AngscaleBias*(2*rand()-1); 

AngscaleNoise = 0.001; % [rad/s]
AngFieldNoise = AngscaleNoise*(2*rand()-1);
function [BxI, ByI, BzI] = get_mag_field_Earth(date, r)
planet
%% Call the magnetic field model

%% Convert Cartesian x, y, z into Lat, Lon, altitude
rho = norm(r);
phiE = 0;
thetaE = acos(r(3)/ rho);
psiE = atan2(r(2), r(1));
latitude = 90 - thetaE * 180 / pi;
longitude = psiE * 180 / pi;
altitude = rho / 1000; % From Center of the Earth
[BN, BE, BD] = igrf(date, latitude, longitude, altitude, 'geocentric');

% Convert from NED to Latitude Longtitude and Altitude
BNED = [BN; BE; -BD]; % Negative because z is going up?
BI = NED2LATLONGALT(phiE, thetaE+pi, psiE) * BNED;
BxI = BI(1);
ByI = BI(2);
BzI = BI(3);

end
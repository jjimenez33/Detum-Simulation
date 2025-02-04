function ptp = quat2euler(q)
%%ptp = quat2euler(q0123)
%input is a Nx4 vector with quaternions.
%output is a Nx3 vector of 3-2-1 euler angles

q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

ptp(:,1) = (atan2(2.*(q0.*q1 + q2.*q3),1-2.*(q1.^2 + q2.^2))); %phi
ptp(:,2) = asin(2.*(q0.*q2-q3.*q1)); %theta
ptp(:,3) = atan2(2.*(q0.*q3 + q1.*q2),1-2.*(q2.^2 + q3.^2)); %psi


ptp = real(ptp);

if nargin < 2
    iplot = 0;
end
if iplot
    Names = {['\phi(deg) ',BodyName],['\theta(deg) ',BodyName],['\psi(deg) ',BodyName]};
    for ii = 1:3
        plottool(1,'PTP',18,'Time(sec)',Names{ii});
        f = 180./pi;
        plot(t,f.*ptp(:,ii),'k-','LineWidth',2)
    end
end

% Copyright - Carlos Montalvo 2015
% You may freely distribute this file but please keep my name in here
% as the original owner
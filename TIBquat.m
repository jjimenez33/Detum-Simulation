function R = TIBquat(q)
%compute R such that v(inertial) = R v(body)
% This takes a quaternion and rotates it to the body frame
q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

R = [(q0^2+q1^2-q2^2-q3^2) 2*(q1*q2-q0*q3)  2*(q0*q2+q1*q3);
      2*(q1*q2+q0*q3) (q0^2-q1^2+q2^2-q3^2) 2*(q2*q3-q0*q1);
      2*(q1*q3-q0*q2) 2*(q0*q1+q2*q3) (q0^2-q1^2-q2^2+q3^2)];

% Copyright - Carlos Montalvo 2015
% You may freely distribute this file but please keep my name in here
% as the original owner
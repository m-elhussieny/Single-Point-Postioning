function [Xsat_rot] = earth_rotation_correction(traveltime, Xsat, Omegae_dot)

%Xsat to column
Xsat = Xsat(:);

%find the rotation angle
omegatau = Omegae_dot * (traveltime+0.00173454);

%build a rotation matrix
R3 = [ cos(omegatau)    sin(omegatau)   0;
      -sin(omegatau)    cos(omegatau)   0;
       0                0               1];

%apply the rotation
Xsat_rot = R3 * Xsat;


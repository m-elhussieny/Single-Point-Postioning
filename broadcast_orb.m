% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudo-range in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to calculate satellite postion and satellite clock offset 
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [sat_pos,dtsat] = broadcast_orb(tow, toe, a0, a1, a2, roota, dn, m0, e, omega, omega0, omegadot, cuc, cus, crc, crs, cic, cis, i0, idot )
% BROADCAST_ORB returns the coordinate and velocity of satellite in addition
% to it clock offset.
% Inputs:
%   Parameters | all element broadcasted in the navigation message.
% Outputs:
% sat_pos | satellite position in (x,y,z) and (vx,vy,vz)
% dtsat   | satellite clock offset
% History:
%   17-10-2021 | eng | written
% -------------------------------------------------------------------------
% initialization
mu              = 3.986005d14;     % Earth's gravitational constant
wearth          = 7.2921151467d-5; % Angular velocity of the earth
clight          = 299792458.d0;    % light velocity
rtol_kepler     = 1d-13;           % relative tolerance for Kepler equation 
max_iter_kepler = 30;              % max number of iteration of Kepler 
% -------------------------------------------------------------------------
% time diff
dt = tow - toe;
%--------------------------------------------------------------------------
% ephemeris parameter
a  = roota^2;
%--------------------------------------------------------------------------
% compute mean anomaly
xn = sqrt(mu/a^3);
mk = xn + dn;
mk = m0 + mk*dt;
% -------------------------------------------------------------------------
% iterate to solve eccentric anomly Ek
n=0;ek=mk;ex=0.d0;
while(abs(ek-ex)>rtol_kepler && n<max_iter_kepler)
    ex=ek; ek=ek-(ek-e*sin(ek)-mk)/(1.d0-e*cos(ek));
    n=n+1;
end
if(n>=max_iter_kepler), return; end
% -------------------------------------------------------------------------
% determination of true anomaly V
v0 = 1.d0 - e*cos(ek);
vs = sqrt(1.d0 - e*e)*sin(ek)/v0;
vc = (cos(ek) - e)/v0;
v = atan2(vs, vc);
%--------------------------------------------------------------------------
% determine the latitude argument, radial distance, plane inclination.
phi = v + omega;
ccc = cos(2*phi);
sss = sin(2*phi);
du  = cuc*ccc + cus*sss;
dr  = crc*ccc + crs*sss;
di  = cic*ccc + cis*sss;
r   = a*(1 - e*cos(ek)) + dr;
u   = phi + du;

xi = i0 + di + idot*dt;
xx = r*cos(u);
yy = r*sin(u);

xnode = omega0 + (omegadot - wearth)*dt;
xnode = xnode - wearth*toe;
% -------------------------------------------------------------------------
% coordinate after the rotation matrix R
sat_pos(1) = xx*cos(xnode) - yy*cos(xi)*sin(xnode);
sat_pos(2) = xx*sin(xnode) + yy*cos(xi)*cos(xnode);
sat_pos(3) = yy*sin(xi);

% -------------------------------------------------------------------------
% velocity
term  = (xn*a)/sqrt(1.d0 - e*e);
xpdot = -sin(u)*term;
ypdot = (e + cos(u))*term;
asc   = xnode;
xinc  = xi;
xp    = xx;
yp    = yy;

asctrm = (omegadot - wearth);
sat_pos(4) = xpdot*cos(asc) - ypdot*cos(xinc)*sin(asc)...
        - xp*sin(asc)*asctrm - yp*cos(xinc)*cos(asc)*asctrm;
sat_pos(5) = xpdot*sin(asc) + ypdot*cos(xinc)*cos(asc)...
        + xp*cos(asc)*asctrm - yp*cos(xinc)*sin(asc)*asctrm;
sat_pos(6) = ypdot*sin(xinc);
% -------------------------------------------------------------------------
% satellite clock correction
dtsat = a0 + (a1 + a2*dt)*dt;

% -------------------------------------------------------------------------
% relativity correction 
dt = dt - dtsat;
dtsat=a0 + (a1 + a2*dt)*dt;
dtsat=dtsat-2.d0*sqrt(mu*a)*e*sin(ek)/(clight*clight);
end
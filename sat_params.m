% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudo-range in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to calculate the azimuth, elevation, and distance between  
% satellite and receiver
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [azmth,elev,dist]=sat_params(rcv_x,rcv_y,rcv_z,phi,lam,sat_x,sat_y,sat_z)
% SAT_PARAMS return the azimuth, elevation, and distance between satellite 
% and receiver
% Inputs:
%   (rcv_x,rcv_y,rcv_z) | receiver coordinate in (x,y,z)
%   (sat_x,sat_y,sat_z) | satellite coordinate in (x,y,z)
%   phi | latitude angle (radians)
%   lam |  longitude angle (radians)
% Outputs:
%   azmth | azimuth of satellite with respect to receiver
%   elev  | elevation angle of satellite with respect to receiver
%   dist  | distance between satellite and receiver
% History:
%   17-10-2021 | eng | written.
%--------------------------------------------------------------------------
% angles
rlat=phi-pi/2.0; rlon=lam-pi;
srlat=sin(rlat); crlat=cos(rlat);
srlon=sin(rlon); crlon=cos(rlon);
% -------------------------------------------------------------------------
% coordinate diff
dx=sat_x-rcv_x;
dy=sat_y-rcv_y;
dz=sat_z-rcv_z;
%--------------------------------------------------------------------------
% transformation
du=crlat*crlon*dx+ crlat*srlon*dy -srlat*dz;
dv=srlon*dx      - crlon*dy;
dw=srlat*crlon*dx+ srlat*srlon*dy+ crlat*dz;

% -------------------------------------------------------------------------
% parameters (distance, elevation, azimuth)
dist= sqrt(du^2+dv^2+dw^2);
azmth  = rad2deg(atan2(dv,du));
elev  = rad2deg(asin(dw/dist));
% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudorange in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% Estimate receiver coordinates and receiver clock offset
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear;
%--------------------------------------------------------------------------
% initialized vectors and matrices
sat_pos=zeros(8,6); dtsat=zeros(8,1);
%--------------------------------------------------------------------------
% constants/files
clight = 299792458.d0;
nav_file='eph.dat';     % navigation file
obs_file='rcvr.dat';    % observation file
m = 4;                  % number of unknowns or estimated parameters
%--------------------------------------------------------------------------
% read satellite navigation data
[~,iprn_orb,toe,a0,a1,a2,e,roota,dn,m0,idot,i0,omega,omega0,omegadot,...
    cus,cuc,cis,cic,crs,crc] =read_nav(nav_file);
%--------------------------------------------------------------------------
% read observation data
[tow,iprn_obs,code] =read_obs(obs_file);
n = length(code);   %number of pseudo-range observations or equations
%--------------------------------------------------------------------------
% compute satellite positions and clocks 
for i=1:length(iprn_obs)
    iprn = iprn_obs(i);
    index = find(iprn_orb==iprn);
    [sat_pos(i,1:6),dtsat(i,1)] = broadcast_orb(tow(index,1)-(code(index,1)/clight), ...
        toe(index,1), a0(index,1), a1(index,1), a2(index,1), roota(index,1), ...
        dn(index,1), m0(index,1), e(index,1), omega(index,1), omega0(index,1), ...
        omegadot(index,1), cuc(index,1), cus(index,1), crc(index,1), crs(index,1), ...
        cic(index,1), cis(index,1), i0(index,1), idot(index,1));
%     [xsat(i,1:3)] = earth_rotation_correction(code(i,1)/clight, xsat(i,1:3), omegadot(i,1));
end
%--------------------------------------------------------------------------
% Write results
write_satpos(iprn_obs,sat_pos, dtsat,"satelite.txt");
%--------------------------------------------------------------------------
% initial receiver coordinates and unknowns
rcv_pos   = [-2694685.473; -4293642.366; 3857878.924];
clock_bias = 0;
% rece_pos = [-2700400;     -4292560;     3855270];
%--------------------------------------------------------------------------
% geodetic coordinates
[wlat, wlon, walt] = Wgsxyz2lla(rcv_pos);
%--------------------------------------------------------------------------
% loop for code observations
% -------------------------------------------------------------------------
azmth=zeros(n,1); elev=zeros(n,1); dist=zeros(n,1); A=zeros(n,4); 
computed_range=zeros(n,1); observed_range=zeros(n,1); Q=zeros(n,n);
iter = 1;
while(true)
    icount=1;
    for isat=1:n
%--------------------------------------------------------------------------
        % elevation/azimuth/distance computation
        [azmth(isat,1),elev(isat,1),dist(isat,1)]=sat_params(rcv_pos(1),rcv_pos(2),rcv_pos(3),deg2rad(wlat),deg2rad(wlon),sat_pos(isat,1),sat_pos(isat,2),sat_pos(isat,3));
% -------------------------------------------------------------------------
        % design or coefficient matrix
        A(icount,1) = (rcv_pos(1) - sat_pos(isat,1))/dist(isat,1); % coefficient for X coordinate unknown
        A(icount,2) = (rcv_pos(2) - sat_pos(isat,2))/dist(isat,1); % coefficient for Y coordinate unknown
        A(icount,3) = (rcv_pos(3) - sat_pos(isat,3))/dist(isat,1); % coefficient for Z coordinate unknown
        A(icount,4) =  1;                                        % coefficient for receiver clock OFFSET 
% -------------------------------------------------------------------------
        % computed range vector
        computed_range(icount,1) = dist(isat,1) + clock_bias - clight*dtsat(isat,1);
% -------------------------------------------------------------------------
        % observed range vector
        observed_range(icount,1) = code(isat,1) ;
% -------------------------------------------------------------------------
        % observation covariance matrix
        % piror_sigma=1;
        % Q(icount,icount) = (piror_sigma)^2 /(sin(deg2rad(elv(isat,1))))^2;
        Q(icount,icount) = 1 ;
        
        icount=icount+1;
    end
% -------------------------------------------------------------------------    
    % misclosure vector
    diff = observed_range-computed_range;
% -------------------------------------------------------------------------
    % least squares adjustment 
    Weight=diag((diag(Q).^-1));
% -------------------------------------------------------------------------
    % normal matrix
    N = (A'*(Weight)*A);
    if (n >= m) 
        % least squares solution
        x = (N^-1)*A'*(Weight)*(observed_range-computed_range);
        % estimation of the variance of the observation error
        residuals = (A*x + computed_range)-observed_range;        
    end
% -------------------------------------------------------------------------
    % update parameters
    rcv_pos   = rcv_pos   + x(1:3);
    clock_bias = clock_bias + x(4);
% -------------------------------------------------------------------------
    % a posteriori covariance matrix of the estimation error
    post_sigma = (residuals'*(Weight)*residuals)/(n-m);
    Cxx = diag(diag(N^-1));
    std = sqrt(Cxx)*sqrt(post_sigma);
% -------------------------------------------------------------------------
    % calculate DOP
    cov = (A'*A)^-1;
    pdop = sqrt(cov(1,1)+cov(2,2)+cov(3,3));
    gdop = sqrt(cov(1,1)+cov(2,2)+cov(3,3)+cov(4,4));
% -------------------------------------------------------------------------
    % write results
    write_result(iter, x, rcv_pos, clock_bias, pdop, gdop, std)
    write_resdiuals(iter, iprn_obs, azmth, elev, residuals);
    
    iter = iter + 1;
    dx   = norm(x(1:3));
    if (dx<1e-4), break; end
end


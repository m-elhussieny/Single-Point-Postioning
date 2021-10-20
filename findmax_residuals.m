% -------------------------------------------------------------------------
% This in my implimntation of Single POINT Positioning (SPP) using
% pseudorange in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud ElHussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to find the maximum residual based on residual limit
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [res_max, iprn_rej, index] = findmax_residuals(residuals,iprn_obs, iprn_rej)
% FINDMAX_REIDUIALS returns the maximum residual, the rejected satlite
% number, index of obseration
% Inputs:
%   residuals: the residual vector fro the last iteration
%   iprn_obs: the obseved satellite number
%   iprn_rej: the rejected satellite number incresed every time 
% Outputs:
%   res_max  | maximum value of absolute residuals
%   iprn_rej | satellite number to be rejected
%   index    | index of satellite observation to be rejected
% History:
%   17-10-2021 | eng | Written
% -------------------------------------------------------------------------
res_max = max(abs(residuals));
for i=1:length(residuals)
    if abs(residuals(i)) == res_max
        index=i;
        iprn_rej(length(iprn_rej)+1) = iprn_obs(i);
    end
end
end
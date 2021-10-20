% -------------------------------------------------------------------------
% This in my implimntation of Single POINT Positioning (SPP) using
% pseudorange in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud ElHussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to reject some observations based on the limit of residual
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [iprn_obs,xsat,dtsat,code]=reject_obs(iprn_obs,xsat,dtsat,code,index)
% REJECT_OBS returns the updated satellite number, satellite cooredinates,
% satellite clock offset, and observed range
% Inputs:
%   iprn_obs | the vector of satellite number
%   xsat     | array of satellite coordinates
%   dtsat    | the vector of satellite clock offset
%   code     | the vector of the observed code range
%   index    | the index of the rejected observation
% Outputs:
%   iprn_obs | the vector of satellite number updated after rejecting
%   xsat     | array of satellite coordinates updated after rejecting
%   dtsat    | the vector of satellite clock offset updated after rejecting
%   code     | the vector of the observed code range updated after rejecting
% History:
%   17-10-2021 | eng | written.
%--------------------------------------------------------------------------
for i=1:length(index)
    iprn_obs(index(i))=[];
    dtsat(index(i))=[];
    code(index(i))=[];
    xsat(index(i),:)=[];
end
end
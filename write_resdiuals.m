% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudo-range in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to azimuth, elevation, and residual of satellite to a file
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function write_resdiuals(iter,indx, azmth, elev, resd, filename)
% WRITE_RESULT a function to print residuals in a text file after each
% iteration
% Inputs:
%   iter     | iteration number
%   index    | satellite number 
%   azmth    | azimuth of satellite with respect to receive
%   elev     | elvation angle of satellite with respect to receiver
%   resd     | residual after each iteration
%   filename | name of the file to be print out
% Outputs:
%   .txt | a file with .txt extension  
% History:
%   17-10-2021 | eng | Written
% -------------------------------------------------------------------------
if nargin <= 5
    filename = "satres.txt";
end
opt = 'at';
if iter == 1
    opt = 'wt';
end
fileid = fopen(filename, opt);

fprintf(fileid, "Iteration #%03d | ", iter);
% fprintf(fileid, "---------------------------------------------------------------------------\n");
fprintf(fileid, "%s   %s    %s   %s\n", "#sat", "Azimuth", "Elevation", "Residual");
fprintf(fileid, "---------------------------------------------------------------------------\n");
for i=1:length(azmth)
    fprintf(fileid, "                 ");
    fprintf(fileid, "G%02d %+10.3f %10.3f %+10.3f \n", indx(i,1), azmth(i,1), elev(i,1), resd(i,1));
end
fprintf(fileid, "---------------------------------------------------------------------------\n");
fprintf("\n");
fclose(fileid);
end
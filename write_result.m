% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudo-range in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to write rsults to a file
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function write_result(iter, x, rcv_pos, clock_bias, pdop, gdop, cov, filename)
% WRITE_RESULT a function to print results in a text file after each
% iteration
% Inputs:
%   iter       | iteration number
%   x          | unknown parameters  
%   rcv_pos    | updated receiver position
%   clock_bais | updated clock bias
%   pdop       | total dilution of precision
%   gdop       | ground dilution of precision
%   cov        | standard deviation of each element
%   filename   | name of the file to be print out
% Outputs:
%   .txt | a file with .txt extension  
% History:
%   17-10-2021 | eng | Written
% -------------------------------------------------------------------------
if nargin <= 7
    filename = "result.txt";
end

if iter ==1
    opt = 'wt';
    fileid = fopen(filename, opt);
    fprintf(fileid, "%s   %s        %s        %s        %s      %s    %s    %s    %s   %s     %s\n", ...
        "#iter","ΔX (m)","ΔY (m)","ΔZ (m)", "ΔCLK (m)",...
        "Final X (m)", "Final Y (m)", "Final Z (m)", "Fin CLK (m)", "PDOP", "GDOP"); 
    fprintf(fileid,"                                                                     ");
    fprintf(fileid, "%s         %s         %s       %s\n", ...
        "σX (m)", "σY (m)", "σZ (m)", "σCLK (m)");   
    fclose(fileid);
end
opt = 'at';
fileid = fopen(filename, opt);
fprintf(fileid, "%03d %+13.5f %+13.5f %+13.5f %+15.5f %+14.3f %+14.3f %+14.3f %+13.3f %+8.3f %+8.3f\n", ...
    iter, x(1), x(2), x(3), x(4), rcv_pos(1), rcv_pos(2), rcv_pos(3), clock_bias, pdop, gdop);
fprintf(fileid,"                                                                      ");
fprintf(fileid, "%6.3f         %6.3f         %6.3f        %6.3f\n",cov(1,1), cov(2,2), cov(3,3), cov(4,4));

fclose(fileid);
end
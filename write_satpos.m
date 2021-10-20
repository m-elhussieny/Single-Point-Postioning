% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudo-range in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to write receiver coordinates, and receiver clock offset to
% a file
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function write_satpos(index, sat_pos, sat_clk, filename)
% WRITE_SATPOS a function to print satellite position in a text file
% Inputs:
%   index      | satellite number
%   sat_pos  | satellite position 
%   sat_clk    | satellite clock offset
%   filename   | name of the file to be print out
% Outputs:
%   .txt | a file with .txt extension 
% History:
%   17-10-2021 | eng | Written
% -------------------------------------------------------------------------
if nargin <=3
    filename="satpos.txt";
end
m =length(index);
fileid = fopen(filename, 'wt');
fprintf(fileid, "%s         %s              %s              %s            %s \n",...
    "#sat", "X (m)", "Y (m)", "Z (m)", "clk (sec)");
fprintf(fileid, "            %s         %s         %s\n",...
    "Vx (m/sec)", "Vy (m/sec)", "Vz (m/sec)");
for i=1:m

    fprintf(fileid,'G%02d %+18.6f %+18.6f %+18.6f %+22.16f \n',...
        index(i,1),sat_pos(i,1),sat_pos(i,2),sat_pos(i,3), sat_clk(i,1));
    fprintf(fileid,'    %+18.6f %+18.6f %+18.6f \n',...
        sat_pos(i,4), sat_pos(i,5),sat_pos(i,6));

end
fclose(fileid);
end
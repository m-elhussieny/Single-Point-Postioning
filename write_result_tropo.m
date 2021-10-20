%--------------------------------------------------------------------------
%  This in my implementation of Single POINT Positioning (SPP) using
%  pseudo-range in my PhD course AAE6102 
%  ------------------------------------------------------------------------ 
%  Author : ABDALLAH, Mahmoud Elhussien Ibrahim
%  Date   : 17-10-2021 
%--------------------------------------------------------------------------
% A function to write result to a file
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function write_result_tropo(iter, x, rece_pos, clock_bias, tropo, pdop, gdop, cov, filename)
if nargin <= 8
    filename = "result_tropo.txt";
end

if iter ==1
    opt = 'wt';
    fileid = fopen(filename, opt);
    fprintf(fileid, "%s   %s        %s        %s        %s          %s  %s    %s    %s    %s   %s     %s     %s\n", ...
        "#iter","ΔX (m)","ΔY (m)","ΔZ (m)", "ΔCLK (m)", "ΔTropo (m)",...
        "Final X (m)", "Final Y (m)", "Final Z (m)", "Fin CLK (m)", "Fin Tropo (m)","PDOP", "GDOP"); 
    fprintf(fileid,"                                                                                     ");
    fprintf(fileid, "%s         %s         %s       %s      %s\n", ...
        "σX (m)", "σY (m)", "σZ (m)", "σCLK (m)", "σTropo (m)");   
    fclose(fileid);
end
opt = 'at';
fileid = fopen(filename, opt);
fprintf(fileid, "%03d %+13.5f %+13.5f %+13.5f %+15.5f %+15.5f %+14.3f %+14.3f %+14.3f %+13.3f %+13.3f    %+8.3f %+8.3f\n", ...
    iter, x(1), x(2), x(3), x(4), x(5), rece_pos(1), rece_pos(2), rece_pos(3), clock_bias, tropo, pdop, gdop);
fprintf(fileid,"                                                                                      ");
fprintf(fileid, "%6.3f         %6.3f         %6.3f        %6.3f        %6.3f\n",cov(1,1), cov(2,2), cov(3,3), cov(4,4), cov(5,5));

fclose(fileid);
end
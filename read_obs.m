% -------------------------------------------------------------------------
% This in my implementation of Single POINT Positioning (SPP) using
% pseudo-range in my PhD course AAE6102 
% -------------------------------------------------------------------------
% Author : ABDALLAH, Mahmoud Elhussien Ibrahim
% Date   : 17-10-2021 
% -------------------------------------------------------------------------
% A function to read observations from .dat observation file.
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function [tow,iprn,code] =read_obs(filename)
% READ_OBS read an observation file with extension .dat
% Inputs:
%   filename | observation file with extension .dat
% Outputs:
%   tow  | time of epoch
%   iprn | satellite number
%   code | observation range
% History:
%   17-10-2021 | eng | Written.
% -------------------------------------------------------------------------

% initialization        
tow =zeros(8,1);
iprn=zeros(8,1);
code =zeros(8,1);


isat=1;

fileid=fopen(filename,'rt');

while(~feof(fileid))
    
    line=fgetl(fileid);
    if (length(line)>1)
        str=sscanf(line(1:16),'%c');
        tow(isat,1)=str2double(str);

        str=sscanf(line(18:19),'%c');
        iprn(isat,1)=str2double(str);

        str=sscanf(line(25:36),'%c');
        code(isat,1)=str2double(str);

        
        isat=isat+1;    
    end
end
fclose(fileid);
end
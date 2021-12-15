function out=snag_diary(onoff,filnam)
% SNAG_DIARY  manages diary a la snag
%
%           out=snag_diary(onoff,filnam)
%     or simply  snag_diary
%
%   onoff       1 or 0 to turn on or off (if different or absent, toggles)
%   filnam      filname (default diary_xxxxx in the snagout directory)

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('onoff','var')
    onoff=-1;
end

if ~exist('filnam','var')
    snag_local_symbols
    filnam=[snagout 'diary_' datestr(now,30) '.txt'];
end

if onoff ~= 1 | onoff ~= 0
    o=get(0,'Diary');
    if strcmp(o,'on')
        onoff=0;
    else
        onoff=1;
    end
end

switch onoff
    case 1
        diary(filnam);
    case 0
        diary off;
end
        
out=get(0,'Diary');
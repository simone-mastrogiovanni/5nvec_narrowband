function s=snag_timestr(tim,typ)
% SNAG_TIMESTR creates a standard format string
%
%    tim     time in serial numerical format or vector [y m d h m s] (def)
%    typ     0 -> 20090209_175633
%            1 -> 20090209
%            2 -> 175633
%
%      ex.: s=snag_timestr(now)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('typ','var')
    typ=0;
end

if length(tim) == 1
    tim=datevec(tim);
end
tim=round(tim);

switch typ
    case 0
        s=sprintf('%4d%02d%02d_%02d%02d%02d',tim);
    case 1
        s=sprintf('%4d%02d%02d',tim(1:3));
    case 2
        s=sprintf('%02d%02d%02d',tim(4:6));
end
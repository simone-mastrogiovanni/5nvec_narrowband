function [tinit cont]=check_mjd(tin,cont)
% CHECK_MJD  checks the plausibility of mjd time init and transforms it
%
% This procedure is important because often the beginning of an sfc file is
% in mjd and the dt is in seconds
%
%    tin    sfc structure
%    cont   0 -> no change
%           1 -> if mjd (40000<t<70000) puts it to 0
%           2 -> if mjd (40000<t<70000) puts it in seconds from day beginning
%           3 -> if mjd (40000<t<70000) puts it in seconds from hour beginning
%           4 -> if mjd (40000<t<70000) puts it in seconds from minute beginning
%          -1 -> asks

% Version 2.0 - July 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

tinit=tin;

if tin < 40000 | tin > 70000
    return
end

if cont == -1
    answ=listdlg('PromptString','MJD abscissa mode:','SelectionMode','single',...
        'ListString',{'No change','0','Day start','Hour start','Minute start'});
    cont=answ-1;
end

switch cont
    case 0
        return
    case 1
        tinit=0;
    case 2
        tinit=(tinit-floor(tinit))*86400;
    case 3
        tinit=(tinit*24-floor(tinit*24))*3600;
    case 4
        tinit=(tinit*24*60-floor(tinit*24*60))*60;
end
function g=dds2gd_selind(file,k,minind,maxind,cont)
%dds2GD_SELIND  creates a gd with a selection of the data of an dds file
%
%   file       input file
%   k          number of the channel
%   minind     min index
%   maxind     max index
%   cont   0 -> no change
%          1 -> if mjd (40000<t<70000) puts it to 0
%          2 -> if mjd (40000<t<70000) puts it in seconds from day beginning
%          3 -> if mjd (40000<t<70000) puts it in seconds from hour beginning
%          4 -> if mjd (40000<t<70000) puts it in seconds from minute beginning
%          -1 or absent -> asks

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dds_=dds_open(file);

if ~exist('cont','var')
    cont=-1;
end
tinit=check_mjd(dds_.t0,cont);

if minind > 1
    dds_seek(dds_,minind);
end

maxind=min(maxind,dds_.len);
A=fread(dds_.fid,[dds_.nch,maxind-minind+1],'double');

g=gd(A(k,:));

tinit=tinit+minind*dds_.dt;

switch cont
    case 1
        tinit=0;
    case 2
        tinit=mod(tinit,86400);
    case 3
        tinit=mod(tinit,3600);
    case 4
        tinit=mod(tinit,60);
end

g=edit_gd(g,'ini',tinit,'dx',dds_.dt,'capt',dds_.capt);

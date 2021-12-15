function g=sds2gd_selind(file,k,minind,maxind,cont)
%SDS2GD_SELIND  creates a gd with a selection of the data of an sds file
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

sds_=sds_open(file);

if ~exist('cont','var')
    cont=-1;
end
tinit=check_mjd(sds_.t0,cont);

if minind > 1
%     A=fread(sds_.fid,[sds_.nch,minind-1],'float');
    sds_seek(sds_,minind);
end

maxind=min(maxind,sds_.len);
A=fread(sds_.fid,[sds_.nch,maxind-minind+1],'float');

g=gd(A(k,:));

tinit=tinit+minind*sds_.dt;

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

g=edit_gd(g,'ini',tinit,'dx',sds_.dt,'capt',sds_.capt);

function out=bsd_dayplot(bsd,typ)
% plots a bsd with better abscissa
%
%     out=bsd_dayplot(bsd,typ)
%
%  bsd    input bsd
%  typ    type of abscissa start:
%          1  day  (default)
%          2  week
%          3  month
%          4  year

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Rome University

if ~exist('typ','var')
    typ=1;
end

dt0=dx_gd(bsd);
% ini0=ini_gd(bsd);

cont=ccont_gd(bsd);
t0=cont.t0;
pday=t0-floor(t0);
[v dow doy dom]=mjd2v(t0);

dt=dt0/86400;
ini=pday;

switch typ
    case 2
        ini=ini+dow;
    case 3
        ini=ini+dom;
    case 4
        ini=ini+doy;
end

nobsd=cont;
cont=[];
cont.nobsd=nobsd;

out=edit_gd(bsd,'ini',ini,'dx',dt,'cont',cont,'capt','nobsd');

figure,plot(out)

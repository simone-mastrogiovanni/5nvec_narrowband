function gout=gdadv2gd(gadv,ic)
% conversion gdadv to gd
%
%    gadv   gdadv to convert
%    ic     = 0 loose tfstr and adv, = 1 tfstr and adv substructures of cont

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

gout=gd(gadv.y);
cont=gadv.cont;
if ic > 0
    cont.tfstr=gadv.tfstr;
    cont.adv=gadv.adv;
end

gout=edit_gd(gout,'x',gadv.x,'ini',gadv.ini,'dx',gadv.dx,'type',gadv.type,...
    'cont',cont,'capt',gadv.capt,'unc',gadv.unc,'uncx',gadv.uncx);
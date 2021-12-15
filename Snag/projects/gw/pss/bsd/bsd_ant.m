function ant=bsd_ant(bsd)
% extracts antennas data from a bsd
%

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

cont=ccont_gd(bsd);

ant1=cont.ant;

switch ant1
    case 'ligol'
        ant=ligol();
    case 'ligoh'
        ant=ligoh();
    case 'virgo'
        ant=virgo();
end
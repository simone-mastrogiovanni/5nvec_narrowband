function candout=cand_corr(cand,coin)
% correct the frequency for the spin-down at coincidence time and permutes
% cands ordering for clusters
%
%       candout=cand_corr(cand,coin)
%
%    cand     candidate structure
%    coin     coincidence structure
%    kgroup   1 or 2, depending on the coincidence group of the candidates
%
%    candout  corrected output matrix

% Snag Version 2.0 - November 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

T1=coin.T1;
T2=coin.T2;
Tcoin=coin.T0;
Tcand=cand.info.run.epoch;

switch Tcand
    case T1
        k=1;
        perm=coin.perm1;
    case T2
        k=2;
        perm=coin.perm2;
    otherwise
        disp(' *** Error !')
        return
end
            
candout=sd_corr_1(cand.cand,Tcand,Tcoin,1);

candout=candout(perm,:);


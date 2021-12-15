function out=ana_soft_inj(injsour,cands)
%
%    out=ana_soft_inj(injsour,cands)
%
%  injsour    (16,N) injected sources
%     1         inj freq
%     2         inj lambda
%     3         inj beta
%     4         inj s.d.
%     5         inj h
%     6         inj hnorm
%     7         inj eta
%     8         inj psi
%     9         detected freq
%    10         detected lambda
%    11         detected beta
%    12         detected s.d.
%    13         detected h
%    14         detected hnorm (inessential)
%    15         unc lambda
%    16         unc beta
%    17         computed eta
%    18         computed psi
%  cands      detected candidates for upper limit
%    1.         frequency
%    2.         lambda
%    3.         beta
%    4.         spin-down
%    5.         h

% Snag version 2.0 - January 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome


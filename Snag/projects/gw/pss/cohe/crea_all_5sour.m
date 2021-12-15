function [S modS]=crea_all_5sour(hp,hx,neta,npsi)
% CREA_ALL_5SOUR  starting from hp and hx, creates the 5 components for all
%                 possible sources response. The computation is performed
%                 for the two rotations
%
%       [S modS]=crea_all_5sour(hp,hx,neps,npsi)
%
%    hp          h plus antenna response (5-vector)
%    hx          h cross antenna response (5-vector)
%    neta,npsi   number of points in the parameter spaces

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

deta=2/(neta-1);
dpsi=90/npsi;

eta=(0:neta-1)*deta-1;
psi=(0:npsi-1)*dpsi;

[S modS]=nf_risp_ant(hp,hx,eta,psi);

figure,image(psi,eta,modS,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('eta')
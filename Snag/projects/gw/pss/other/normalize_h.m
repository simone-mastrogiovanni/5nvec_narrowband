function [hnorm,detl]=normalize_h(in,detlev)
%
%   hnorm=normalize_h(in,noise)
%
%   in      (n,2) [freq h]
%   detlev  detection level
%
% for example the detlev for single "antenna" is (N1 wieneriz.noise,n01=Tobs/Tfft, level=2)
% H1=level*N1*10^-20*nO1^-0.25;
% 
% in the case of coincidences is H0:
% H1=level*N1*10^-20*nO1^-0.25;
% H2=level*N2*10^-20*nO2^-0.25;
% H0=max(H1,H2);

% Snag version 2.0 - January 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

detl=gd_interp(detlev,in(:,1));
hnorm=in(:,2)./detl;
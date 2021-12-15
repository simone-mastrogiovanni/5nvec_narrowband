function [chiq A mf]=chiq_5comp(data,sig,nois)
% CHIQ_5COMP  computes the chi square for a given signal
%
%    [chiq A mf]=chiq_5comp(data,sig,nois)
%
%    data    5 comp data
%    sig     5 comp signal
%    nois    variance of the noise or 1

% Version 2.0 - June 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

mf=conj(sig)./sum(abs(sig).^2);
A=sum(data.*mf);

chiq=sum(abs(data-A*sig).^2)/nois;
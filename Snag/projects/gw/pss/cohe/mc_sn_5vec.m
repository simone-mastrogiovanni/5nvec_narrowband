function [sig,nois,sigeta,sigpsi]=mc_sn_5vec(ant,sour,N,randph)
% montecarlo with 5-vect
%
%  ant    antenna (0             -> all parameters
%                  ant struct    -> fixed antenna)
%  sour   source  (0             -> all parameters
%                  [alpha,delta] -> fixed position
%                 sour struct   -> fixed source)
%  N      MC dimension
%  randph random phase (source RA: 0 or 1; def 0)

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

MCF=crea_mc_filter(ant,sour,N,randph);
sig=MCF.mcf;
% sigeta=MCF.ksour(2,:);
% sigpsi=MCF.ksour(3,:);
sigeta=MCF.eta;
sigpsi=MCF.psi;

nois=sig*0;

for i = 1:5
    nois(i,:)=randn(1,N)+1j*randn(1,N);
end

% an=sqrt(sum(abs(nois).^2));
% man=mean(an)
man=sqrt(2*5);
nois=nois/man;
    
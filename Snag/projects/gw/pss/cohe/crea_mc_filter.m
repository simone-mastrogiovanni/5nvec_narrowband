function MCF=crea_mc_filter(ant,sour,N,randph)
% create a  
%
%  ant    antenna (0             -> all parameters
%                  ant struct    -> fixed antenna)
%  sour   source  ([]            -> all parameters
%                  delta         -> fixed position
%                  sour struct   -> fixed source)
%  N      MC dimension
%  randph random phase (source RA: 0 or 1; def 0)

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome


if ~exist('randph','var')
    randph=0;
end
if isnumeric(sour) && length(sour) == 1
    sour=[0 sour];
end

MCF=mc_5vec(ant,sour,N,randph,0);

mcf=MCF.v;
av=sqrt(sum(abs(mcf).^2));
MCF.av=av;

for i = 1:N
    mcf(:,i)=MCF.v(:,i)/av(i);
end

MCF.mcf=mcf;
MCF.N=N;
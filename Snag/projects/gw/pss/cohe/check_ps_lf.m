function [A0 A45 Al Ar l0 l45 cr cl]=check_ps_lf(sour,ant,N,icpl)
% CHECK_PS_LF  computes the low frequencies for the 4 basic polarizations
%               in one sidereal day
%
%      N     number of samples
%      icpl  plot control

% Version 2.0 - January 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('icpl','var')
    icpl=1;
end

sour1=sour;

sour1.eta=0;
sour1.psi=0;

[l0 A0]=sim_ps_st(sour1,ant,N);
l0=real(l0);

sour1.eta=0;
sour1.psi=45;

[l45 A45]=sim_ps_st(sour1,ant,N);
l45=real(l45);

sour1.eta=1;
sour1.psi=0;

[cl Al]=sim_ps_st(sour1,ant,N);

sour1.eta=-1;
sour1.psi=0;

[cr Ar]=sim_ps_st(sour1,ant,N);

x=(0:N-1)*24/N;
if icpl > 0
    figure,plot(x,l0),hold on,plot(x,l45,'r'),grid on
    xlabel('Sidereal time'),title('+ mode (blue), x mode (red)'),xlim([0 24])
    figure,plot(cl,'k'),hold on,plot(cr,'g'),grid on
    plot(cl(1),'ko'),plot(cl(round(N/24)),'kx'),plot(cr(1),'go'),plot(cr(round(N/24)),'gx')
    title('Circular polarization (black left, green right)')
end
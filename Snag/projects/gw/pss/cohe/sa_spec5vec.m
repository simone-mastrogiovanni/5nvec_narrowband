function [fs,v]=sa_spec5vec(sour,ant,band)
% frequency and spectral amplitude 5-vect
%
%   fs=sa_spec5vec(sour,ant,band)
%
%   sour,ant  source (update, antenna
%   band      band bias (for the bsd) = -1 auto

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J Piccinni,S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Tsid=86164.090530833; % at epoch2000

if ~exist('band','var')
    band=0;
end

if band == -1
    band=floor(sour.f0/10)*10;
end

[L0, L45, CL, CR, v, Hp, Hc]=sour_ant_2_5vec(sour,ant);

fs(1,:)=sour.f0+(-2:2)/Tsid-band;
fs(2,:)=abs(v).^2;

figure,semilogy(fs(1,:),fs(2,:),'*'),grid on,title('5-vect spectral lines'),xlabel('Hz'),ylabel('spectral amplitudes')

vers=v./abs(v);
figure,plot([0,real(vers(1))],[0,imag(vers(1))],'r'),hold on
plot([0,real(vers(2))],[0,imag(vers(2))],'b')
plot([0,real(vers(3))],[0,imag(vers(3))],'k')
plot([0,real(vers(4))],[0,imag(vers(4))],'c')
plot([0,real(vers(5))],[0,imag(vers(5))],'m'),grid on
x=cos(0:0.1:2*pi);
y=sin(0:0.1:2*pi);
plot(x,y,'g'),title('5-vect angles (-2 r, -1 b, 0 k, 1 c, 2 m)')
sidpat=pss_sidpat(sour,ant,500);
figure,plot(sidpat),xlim([0,24]),title('Radiation Pattern'),xlabel('GST')
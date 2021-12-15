function [gout,fr,lfr,fr0,ph0]=vfs_create(n,dt,pols,sins,inp,amp)
% create varying frequency signals
%
%     [gout,fr,lfr,fr0,ph0]=vfs_create(n,dt,pols,sins,inp)
%
%   n     number of samples
%   dt    sampling time (negative -> complex signal)
%   pols  polinomial coefficient (1 fr0, 2 sd, ...)
%          pols(1) can be complex (fr0+j*ph0 (ph0 in deg))
%   sins  sinusoids (m,3) (A,fr,ph(deg)) sins=0 -> no sin
%   inp   irregular input frequency (if exist; will be resampled to n)
%   amp   amplitude vector (if present; it will be interpolated)
%
%  ex.: [gout,fr,lfr,fr0,ph0]=vfs_create(10000,-0.1,1,[0.1,0.01,0]);

% Version 2.0 - October 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

tic
icreal=1;
if dt < 0
    dt=-dt;
    icreal=0;
end

t=(0:n-1)'*dt;
T=n*dt;
npol=length(pols);
[nsin,dum]=size(sins);
if sins(1) == 0
    nsin=0;
end

if exist('inp','var')
    ninp=length(inp);
%     fr=interp1(0:ninp-1,inp,(0:n-1)*(ninp-1)/(n-1));
    fr=spline(0:ninp-1,inp,(0:n-1)*(ninp-1)/(n-1));
else
    fr=t*0;
end

fr=fr(:);

fr0=real(pols(1));
ph0=imag(pols(1));
fr=fr+fr0;

for i = 2:npol
    fr=fr+pols(i)*t.^(i-1);
end

for i = 1:nsin
    fr=fr+sins(i,1)*sin((sins(i,2)*t+sins(i,3)/360)*2*pi);
end

lfr=fr-fr0;

gout=cumsum(fr)*dt*2*pi;

if icreal == 1
    gout=cos(gout+ph0*pi/180);
else
    gout=exp((gout+ph0*pi/180)*1j);
end

if sum(fr > 0.5/dt)
    disp('ATTENTION ! high sampling time')
end

if nsin > 0
    if sum(abs(pols(1)) < sins(:,2))
        disp('ATTENTION ! modulation frequency higher than modulated')
    end
end

if exist('amp','var')
    ii=find(amp < 0);
    amp(ii)=0;
    namp=length(amp);
    amp1=interp1(0:namp-1,amp,(0:n-1)*(namp-1)/(n-1));%size(amp1),size(gout)
    gout=gout.*amp1';
end
    
gout=gd(gout);
gout=edit_gd(gout,'dx',dt); toc
function [gout,lfr,frtot]=intr_doppler(fr0,P,damp,ph,ecc,n,dt,typ)
% Intrinsic Doppler for binaries
%
%    [gout,lfr]=intr_doppler(fr0,P,amp,ph,ecc,n,dt,typ)
%
%  fr0    source frequency (Hz)
%  P      orbital period (s)
%  damp   Doppler amplitude (max-min)/2(Hz)
%  ph     ascending node phase (degrees)
%  ecc    eccentricity
%  n      number of samples
%  dt     sampling time
%  typ    can be absent. =5 sidereal 5-vec (mat, not gd)

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=1;
end

ST=86164.09053083288;

t=(0:n-1)*dt;
lfr=damp*(sin((t*2*pi/P-ph*pi/180))+ecc*sin(2*(t*2*pi/P-ph*pi/180)));

if typ == 5
    gout=zeros(n,5);
    for i = -2:2
        frtot=fr0+i/ST+lfr;
        phtot=2*pi*cumsum(frtot)*dt;
        gout(:,i+3)=exp(1j*phtot);
    end
else
    frtot=fr0+lfr;
    phtot=cumsum(2*pi*frtot)*dt;
%     gout=exp(1j*phtot);
    gout=sin(phtot);
	gout=gd(gout);
    gout=edit_gd(gout,'dx',dt);
end
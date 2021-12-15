function out=raw_gw_filt(raw,normfact,band,noband)
% creates a raw h-reconstructed data from raw samples
%
%    h=raw_naut_h(raw,band)
%
%   raw       gd with the raw samples
%   normfact  normalization factor (if unknown, put 1)
%   band      [frmin, frmax]
%   noband    notch (m,2)
%
%   out.whit   for resonant antennas
%   out.wien   for interferometric antennas
%   out.hwhit
%   out.hwien

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('normfact','var')
    normfact=1;
end
y=y_gd(raw);
n0=length(y);
n=ceil(n0/4)*4;
n2=n/2;
n4=n/4;
y(n0+1:n)=0;

m=0;
if exist('noband','var')
    [m,dum]=size(noband);
end
sp=gd_pows(raw,'pieces',10,'resolution',4,'nobias','window',2,'short');
ysp=y_gd(sp);
df0=dx_gd(sp);
whit0=sqrt(1./ysp);
nw0=length(whit0);

iband=ind_from_absc(sp,band);

fondo=min(y(iband(1):iband(2)));

whit0(1:iband(1)-1)=0;
whit0(iband(2)+1:n_gd(sp))=0;

for i = 1:m
    noband1=noband(i,:);
    inoband=ind_from_absc(sp,noband1);
    whit0(inoband(1):inoband(2))=0;
end

whit=interp1((0:nw0-1)*df0,whit0,(0:n2)*df0*nw0/n2)';
whit(n:-1:n2+2)=whit(2:n2);
i=find(isnan(whit));
whit(i)=0;
whit=ifft(whit);
whit(n4+1:n2+n4+1)=0;
whit=real(fft(whit));

f=fft(y);%%size(f),size(whit)

y1=ifft(f.*whit);
out.f=f;
out.whit=whit;

out.hwhit=edit_gd(raw,'y',y1)*normfact;

out.wien=out.whit.*out.whit;
y1=ifft(f.*out.wien);

out.hwien=edit_gd(raw,'y',y1)*normfact;

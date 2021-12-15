function [out,oth]=bsd_ftrim(in,fr,enl,noplot)
% extracts and pre-analyze a very narrow band
%
%   in      input bsd
%   fr      frequency band
%   enl     enlargement factor 
%   noplot  =1 noplot (def 0)

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('noplot','var')
    noplot=0;
end

y=y_gd(in);
dt=dx_gd(in);
n=n_gd(in);

cont=cont_gd(in);
inifr0=cont.inifr;

dfr0=1/(n*dt);

ii=round((fr-inifr0)/dfr0)+1;
fr=(ii-1)*dfr0+inifr0;
oth.band=fr;
cont.inifr=fr(1);
cont.bandw=fr(2)-fr(1);
n1=ii(2)-ii(1)+1;

f=fft(y);
f1=f(ii(1):ii(2));

oth.fy1=f1;
oth.ii=ii;
N=round(n1*enl);
out=ifft(f1,N);
y1=ifft(f1);

dt1=1/(dfr0*n1);
cont.inifr=fr(1);
cont.bandw=fr(2)-fr(1);

out=gd(out);
out=edit_gd(out,'dx',dt1/enl,'cont',cont);
out=bsd_zeroholes(out);
y1=gd(y1);
y1=edit_gd(y1,'dx',dt1,'cont',cont);
oth.y1=y1;

sp1=bsd_pows(y1,1);
sp=bsd_pows(y1,6);
oth.sp=sp;
oth.sp1=sp1;

if noplot ~= 1
    figure,semilogy(sp),grid on,hold on,semilogy(sp1,'r.')
end
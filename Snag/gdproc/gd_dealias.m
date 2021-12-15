function [gout,out]=gd_dealias(gin,truezero,enh)
% signal dealiasing: recovers from undersampling
%
%   out=gd_dealias(gin,truezero,enh)
%
%   gin       input gd
%   truezero  which is the aliased zero frequency
%   enh       the factor to reduce the sampling time (integer)

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(gin);
ini=ini_gd(gin);
y=y_gd(gin);
n=n_gd(gin);

icreal=isreal(y);
band0=1/dt;
dfr=1/(n*dt);
enh0=ceil(truezero/band0+0.001);
enh1=enh0*(icreal+1);
nn=n*enh;

out.band0=band0;
out.enh0=enh0;
out.enh1=enh1;

if enh < enh1
    disp(sprintf(' enh = %d < %d : aliasing not corrected',enh,enh1))
end

% y(n+1:nn)=0;

y=fft(y);

yy=zeros(1,nn);

if icreal  
    yy(n*(enh0-1)+1:n*(enh0-1)+n/2)=y(1:n/2);
    yy(nn:-1:nn/2+2)=conj(yy(2:nn/2));
else
    yy(n*(enh0-1)+1:n*enh0)=y;
end

yy=ifft(yy)*enh;
gout=gd(yy);
gout=edit_gd(gout,'ini',ini,'dx',dt/enh);

function gout=gd_frdomrot(gin,dt)
%GD_FRDOMROT  rotates by any dt value by transformation in the frequency domain
%
%       dt    "time" delay rotation
%

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=gin;

y=y_gd(gin);
dx=dx_gd(gin);
n=n_gd(gin);
capt=capt_gd(gin);

dom=2*pi/(dx*n);
n2=floor(n/2);
n3=n-n2+2;
w=zeros(1,n);
w(1:n2+1)=exp(1i*dom*dt*(0:(n2)));
w(n:-1:n3)=conj(w(2:n2));

y=fft(y);
y=y.*w.';
y=ifft(y);
y=real(y);

gout=edit_gd(gout,'y',y,'addcapt','rotation on:');
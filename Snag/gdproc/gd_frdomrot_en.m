function gout=gd_frdomrot_en(gin,dt,en)
%GD_FRDOMROT_EN  rotates by any dt value by transformation in the frequency domain
%
%       dt    "time" delay rotation
%       en    enhancement factor

% Version 2.0 - December 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

gout=gin;

y=y_gd(gin);
dx=dx_gd(gin);
n=n_gd(gin);
capt=capt_gd(gin);

n1=n*en;
dom=2*pi/(dx*n1);
n12=floor(n1/2);
n13=n1-n12+2;
w=zeros(1,n1);
y1=w;
w(1:n12+1)=exp(-i*dom*dt*en*(0:(n12)));
w(n1:-1:n13)=conj(w(2:n12));
figure, plot(real(w)),hold on,plot(imag(w),'r')

n2=floor(n/2);
y=fft(y);
y1(1:n2)=y(1:n2);
y1(n2+(en-1)*n+1:n1)=y(n2+1:n);
y1=y1.*w;
y1=ifft(y1);
y1=real(y1)*en;

gout=edit_gd(gout,'y',y1,'addcapt','rotation on:','n',n1,'dx',dx/en);
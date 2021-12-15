function m=apply_mulfil(g,n)
%APPLY_MULFIL
%
%   g    input signal (time samples - a gd)
%   n    multiplicity
%
%   m   multiplot structure

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

m.nch=n+3;
m=gd2mp(g,m,1);
m.ch(1).unitx='s';

y=y_gd(g);
mf=crea_mulfil(g,n,'lin');
ly=length(y);
ly1=ly;
if mod(ly,2) == 1
    ly1=ly+1;
    y(ly1)=y(ly);
end
yf=fft(y);
df=1/(ly1*dx_gd(g));
rad2p=sqrt(2*pi);
sy=zeros(ly,1);
ay=sy;

for i = 1:n
    x=(0:ly1/2-1)*df;
    mu=mf.fr(i);
    sig=mf.bw(i)/2;
    filt=sqrt(exp(-((x-mu).^2)/(2*sig^2))/(rad2p*sig));
    filt=half2fullspec(filt);%figure,plot(filt)
    yy=yf.*filt.';
    yy=ifft(yy);
    sy=sy+yy(1:ly);
    ay=ay+abs(real2an(yy(1:ly))).^2;
    m.ch(i+1).x=m.ch(1).x;
    m.ch(i+1).y=yy(1:ly);
    m.ch(i+1).name=sprintf('filt %d',i);
    m.ch(i+1).unitx=m.ch(1).unitx;
    m.ch(i+1).unity=m.ch(1).unity;
end

m.ch(n+2).x=m.ch(1).x;
m.ch(n+2).y=sy;

m.ch(n+2).unitx='s';
m.ch(n+2).name=sprintf('sum',i);
m.ch(n+2).unitx=m.ch(1).unitx;
m.ch(n+2).unity=m.ch(1).unity;

m.ch(n+3).x=m.ch(1).x;
m.ch(n+3).y=sqrt(ay);

m.ch(n+3).unitx='s';
m.ch(n+3).name=sprintf('sum an',i);
m.ch(n+3).unitx=m.ch(1).unitx;
m.ch(n+3).unity=m.ch(1).unity;
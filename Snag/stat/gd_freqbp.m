function fr=gd_freqbp(g,fr0,bw,lp)
% GD_FREQBP estimates frequency variation in a band
%
%   fr=gd_freqbp(g,fr0,bw) 
%
%   g      input gd
%   fr0    central frequency
%   bw     semi-bandwidth
%   lp     low-pass factor (typically >= 1)

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('lp','var')
    lp=1;
end
len=n_gd(g);
dt=dx_gd(g);
fr=y_gd(g);
fr=fft(fr);

dfr=1/(len*dt);
ifr0a=round(fr0/dfr);
ibw=2*round(bw/dfr);
ifr1=ifr0a-ibw;
ifr2=ifr0a+ibw;
nfr=ifr2-ifr1+1;
w=ones(1,nfr);
w(1:ibw/2)=(1-cos((1:ibw/2)*2*pi/ibw))/2;
w(nfr:-1:nfr-ibw/2+1)=w(1:ibw/2);

ibwlp=2*round(ibw*0.5/lp);
nfrlp=2*ibwlp+1;
wlp=ones(1,nfrlp);
wlp(1:ibwlp/2)=(1-cos((1:ibwlp/2)*2*pi/ibwlp))/2;
wlp(nfrlp:-1:nfrlp-ibwlp/2+1)=wlp(1:ibwlp/2);

ii=mod(ifr1:ifr2,len)+1;
if ifr1 >= 0 && ifr2 < len
    fr(1:ifr1)=0;
    fr(ifr2+1:len)=0;
else
    fr(mod(ifr2,len)+1:mod(ifr1,len)+1)=0;
end

fr(ii)=fr(ii).*w.';
%figure,plot(abs(fr)),grid on

fr=ifft(fr);

fr=atan3(fr);%figure,plot(fr),grid on,hold on,plot(fr,'r.')
fr=diff(fr); %figure,plot(fr),grid on

fr=fft(fr);
nout=length(fr);
fr(1:ibwlp+1)=fr(1:ibwlp+1).*wlp(ibwlp+1:nfrlp).';
fr(nout:-1:nout-ibwlp+1)=fr(nout:-1:nout-ibwlp+1).*wlp(ibwlp:-1:1).';
fr(ibwlp+2:nout-ibwlp)=0;
fr=ifft(fr);


fr=gd(fr);
fr=edit_gd(fr,'ini',ini_gd(g)+dt,'dx',dt,'capt','frequency estimate');
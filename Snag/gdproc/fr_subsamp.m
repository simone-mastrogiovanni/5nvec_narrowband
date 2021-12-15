function gout=fr_subsamp(gin,fr,redfact)
% FR_SUBSAMP  subsamples a gd by a given factor, shifting a given frequency
%             the given frequency will be at around frmax/4
%
%      gout=fr_subsamp(gin,fr,redfact)
%
%    gin      input gd
%    fr       given frequency
%    redfac   subsampling factor (it could be not the exact value)
%
%    gout     output gd (in .cont the frequency shift)

% Version 2.0 - March 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(gin);
N=n_gd(gin);
N=floor(N/(redfact*2))*redfact*2;
y=y(1:N);
icompl=1-isreal(y);
frmax=1/dx_gd(gin);
dfr=frmax/N;
fr1=frmax/redfact;
k1=round((fr-fr1/4)/dfr);
if k1 < 1
    k1=1;
end
fr0=(k1-1)*dfr;
n2=round(N/(redfact*2));
y=fft(y);
y=y(k1:k1+n2-1);
dx=dx_gd(gin)*N/(2*n2);

if icompl == 1
    y(n2+1:2*n2)=0;
else
    y(n2+1)=0;
    y(n2+2:2*n2)=y(n2:-1:2);
end

y=ifft(y)*(2*n2)/N;

if icompl == 0
    y=real(y);
end
gout=gd(y);
gout=edit_gd(gout,'ini',ini_gd(gin),'dx',dx,'cont',fr0,'capt','subsampled and frequency shifted data');
function a=ar_lowpass_freq(in,fr,norm)
% AR_LOWPASS_FREQ  frequency domain low-pass of input, various normalizations
%
%    a=ar_lowpass_freq(in,fr,norm)
%
%   in      input data (array or gd)
%   fr      cut frequency
%   norm    normalization type (0 -> no, 1 -> on s.d,, 2 -> on mean

% Version 2.0 - January 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=1;
icobj=0;
if isobject(in)
    dt=dx_gd(in);
    a=y_gd(in);
    icobj=1;
else
    dt=1;
    a=in;
end
a=a(:);
if ~exist('norm','var')
    norm=2;
end

N=length(a);

FR=round(fr*dt*N);

a=fft(a);
lwin=5;
v=(1:lwin)'/lwin;

a(FR+1:FR+lwin)=a(FR+1:FR+lwin).*v(lwin:-1:1);
a(N+2-FR-lwin:N+1-FR)=a(N+2-FR-lwin:N+1-FR).*v;
a(FR+lwin+1:N+1-FR-lwin)=0;

const=sqrt((2*FR+1+sum(v)*2)/N);

a=ifft(a);

if norm == 1
    a=a/const;
end
        
if icobj == 1
    a=edit_gd(in,'y',a,'capt',['low-pass of ' capt_gd(in)]);
end




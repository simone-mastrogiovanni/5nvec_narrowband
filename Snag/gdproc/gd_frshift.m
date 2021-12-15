function gout=gd_frshift(gin,fr,maxfr)
% GD_FRSHIFT  frequency shift (rotation)
%
%    gout=gd_frshift(gin,fr)
%
%   gin     input gd
%   fr      frequency to shift
%   maxfr   cut frequency, if present

% Version 2.0 - April 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if exist('maxfr','var')
    iccut=1;
else
    iccut=0;
end
y=y_gd(gin);
x=x_gd(gin);

y=y.*exp(-1i*2*pi*fr*x);
if iccut == 1
    n=length(y);
    k1=round(maxfr*(x(2)-x(1))*n)
    dk=floor(k1/10)+1
    w=(cos((1:dk)*pi/(dk+1))+1)/2;
    y=fft(y);
    y(k1:k1+dk-1)=y(k1:k1+dk-1).*w.';
    y(n+1-k1:-1:n+2-k1-dk)=y(n+1-k1:-1:n+2-k1-dk).*w.';
    y(k1+dk:n-k1-dk)=0;
    y=ifft(y);
end

gout=edit_gd(gin,'y',y,'capt',[capt_gd(gin) ' shifted']);
function gout=gd_resamp(gin,fact)
% resampling (for type 1 gd with an even number of samples)
%
%   gout=gd_resamp(gin,fact)
%
%  gin    input gd
%  fact   resampling factor (> 1 or < 1)

% Snag Version 2.0 - November 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=n_gd(gin);
in=y_gd(gin);
ini=ini_gd(gin);

if ~iseven(n)
    in=in(1:n-1);
end

nn=round(n*fact/2)*2;
nn1=nn-n;
n2=n/2;
if nn1 < 0
    n2=(n+nn1)/2;
end
out=zeros(nn,1);

in=fft(in);
out(1:n2)=in(1:n2);
out(nn:-1:nn-n2+2)=in(n:-1:n-n2+2);

out=ifft(out)*fact;

dxout=(n-1/fact)/(nn-1);
gout=gd(out);
gout=edit_gd(gout,'ini',ini,'dx',dxout);
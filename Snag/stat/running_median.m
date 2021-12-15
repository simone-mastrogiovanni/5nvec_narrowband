function rmed=running_median(in,n,inst)
% running median
%
%     rmed=running_median(in,n,inst)
%
%   in    input gd or array
%   n     pieces length (even)
%   inst  input sampling time

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~isnumeric(in)
    rmed=in;
    dx=dx_gd(in);
    ini=ini_gd(in);
    in=y_gd(in);
    icgd=1;
else
    dx=1;
    icgd=0;
end

N=length(in);
n2=floor((n+1)/2);
ii=0;
iii=1:n2:N-n+1;
yy=zeros(1,length(iii));

for i = iii
    ii=ii+1;
    yy(ii)=median(in(i:i+n-1));
end

if inst == 1
    ii=0;
    i1=1;
    for i = iii
        ii=ii+1;
        in(i1:i1+n2-1)=yy(ii);
        i1=i1+n2;
        i2=i1-1;
    end
    in(i2:N)=yy(ii);
else
    in=yy;
    ini=ini+dx*n2;
    dx=dx*n2;
end

if icgd == 1
    rmed=edit_gd(rmed,'y',in,'dx',dx,'ini',ini);
else
    rmed=in;
end
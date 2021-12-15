function c=pdf2cdf(p,type,norm)
%PDF2CDF  integral of a gd (or array), from beginning or end;
%         works with uniform sampling
%
%   p      input gd or array
%   type   1 cdf, -1 false-alarm, 0 pdf to be normalized
%   norm   0 no normalization, 1 normalization (and computation of mu and sigma)

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(p,'gd')
    dx=dx_gd(p);
    ini=ini_gd(p);
    capt=capt_gd(p);
    precap='cumulative distribution of ';
    c=p;
    p=y_gd(p);
    isgd=1;
else
    dx=1;
    ini=0;
    isgd=0;
end

p=p(:);

if type == -1
    p=flipdim(p,1);
    precap='integral distribution of ';
end

if ~exist('norm')
    norm=1;
end

if type == 0
    precap='density distribution of ';
    norm=1;
end

if norm == 1
    a=sum(p)*dx;
    if a == 0
        a=1;
    end
    p=p/a;
end

if type ~= 0
    p=cumsum(p)*dx;
    if norm == 1
        p=p/max(p);
    end
else
    x=((0:length(p)-1)*dx)';
    
    mu=sum(x.*p)*dx
    sigma=sum(((x-mu).^2).*p)*dx
end

if type == -1
    p=flipdim(p,1);
end

if isgd == 1
    c=edit_gd(c,'y',p,'capt',[precap capt]);
else
    c=p;
end
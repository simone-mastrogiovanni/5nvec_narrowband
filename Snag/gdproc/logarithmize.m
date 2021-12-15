function [y,mi]=logarithmize(x)
% reduce drastically the dynamics
%
%      [y,mi]=logarithmize(x)
%
%  x   input gd or array
%
%  mi  median abs level (*10 typical threshold)

% Version 2.0 - April 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=x;
if isa(x,'gd')
    x=y_gd(x);
end

re=real(x);
im=imag(x);

sre=sign(re);
sim=sign(im);

i0re=find(re ~= 0);
i0im=find(im ~= 0);

re(i0re)=re(i0re).*sre(i0re);
im(i0im)=im(i0im).*sim(i0im);

mi=1;
% mi=min(sqrt(re(i0re).^2+im(i0im).^2));
% mi=median(sqrt(re(i0re).^2+im(i0im).^2)); % OTTIMO !
if length(i0im) > 0
    mi=sqrt(median(re(i0re))^2+median(im(i0im))^2); % OTTIMO !
    ic=2;
else
    mi=median(re(i0re)); % OTTIMO !
    ic=1;
end

re(i0re)=log10(re(i0re)/mi);
im(i0im)=log10(im(i0im)/mi);
re(i0re)=re(i0re).*sre(i0re);
im(i0im)=im(i0im).*sim(i0im);

x=complex(re,im);

if isa(y,'gd')
    y=edit_gd(y,'y',x);
else
    y=x;
end
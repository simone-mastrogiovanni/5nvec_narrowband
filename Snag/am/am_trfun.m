function trfun=am_trfun(amf,n,dt)
%AM_TRFUN  am filter transfer function
%
%      trfun=am_trfun(amf,n,dt)
%
%   amf     am filter
%   n       number of samples
%   dt      sampling time
%
%   trfun   gd with the transfer function

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fi=(0:n-1)*2*pi/n;
zm1=exp(-j*fi);

num=amf.b0*ones(1,n);
for i = 1:amf.nb
    num=num+amf.b(i)*zm1.^i;
end

den=ones(1,n);
for i = 1:amf.na
    den=den+amf.a(i)*zm1.^i;
end

if amf.bilat == 1
    num=num.*conj(num);
    den=den.*conj(den);
end

trfun=num./den;

figure, loglog(fi,abs(trfun)), grid on

trfun=gd(trfun);
trfun=edit_gd(trfun,'dx',1/(dt*n));
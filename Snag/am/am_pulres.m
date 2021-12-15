function pulres=am_pulres(amf,n,dt)
%AM_PULRES  pulse response of an am filter
%
%    pulres=am_pulres(amf,n,dt)
%
%   amf     am filter
%   n       number of samples
%   dt      sampling time
%
%   pulres   gd with the transfer function

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=zeros(n,1);
if amf.bilat == 0
    x(1)=1;
    ini=0;
else
    n0=floor((n+1)/2);
    x(n0)=1;
    ini=-(n0-1)*dt;
end

pulres=am_filter(x,amf);

figure, plot((0:n-1)*dt,pulres),grid on

pulres=gd(pulres);
pulres=edit_gd(pulres,'dx',dt,'ini',ini);
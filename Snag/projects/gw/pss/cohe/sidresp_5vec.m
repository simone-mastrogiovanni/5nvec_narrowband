function sr=sidresp_5vec(s_5vec,n)
% SIDRESP_5VEC  sidereal time response for a source
%               The output is a complex gd, the |sr|^2
%
%    s_5vec   signal 5-vect
%    n        number of points in the sidereal day

% Version 2.0 - August 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

STh=86164.09053083288/3600;
dt=24/n;
sr=zeros(1,n);

for i = -2:2
    om=2*pi*i/STh;
    sr=sr+s_5vec(i+3)*exp(1j*(0:n-1)*dt*om);
end

sr=gd(sr);
sr=edit_gd(sr,'dx',dt,'capt','sidereal response');

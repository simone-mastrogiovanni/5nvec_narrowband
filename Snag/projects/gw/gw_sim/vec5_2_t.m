function g=vec5_2_t(vec5,N,dt,fr)
% VEC5_2_t  creates a gd with source time data (analytic signal)
%
%      g=vec5_2_t(vec5,N,dt,fr)
%
%     vec5    5-vector
%     N       number of data
%     dt      sampling time
%     fr      frequency

% Version 2.0 - July 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ST=86164.09053083288;

g=zeros(1,N);

for i = -2:2
    om=2*pi*(fr+i/ST);
    g=g+vec5(i+3)*exp(1j*(0:N-1)*dt*om);
end

g=gd(g);
g=edit_gd(g,'dx',dt,'capt','periodic source');

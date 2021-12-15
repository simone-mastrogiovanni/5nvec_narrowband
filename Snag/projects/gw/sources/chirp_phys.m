function out=chirp_phys(M1,M2,ecc,dt,A,s1,s2)
% chirp parameters
%
%   M1,M2  masses (solar units)
%   ecc    eccentricity
%   dt     sampling time
%   s1,s2  spins

% Version 2 - October 2018 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2018  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=10000;
N=15000;
DT=(n-1)*dt;

G_=6.67408e-11; % m^3kg^-1s^-2
c_=299792458; % m/s
Msol_=1.98847e30; % kg

G_c3_sol=(G_/c_^3)*Msol_; % s/Msol

if ~exist('A','var')
    A=1;
end
if ~exist('ecc','var')
    ecc=0;
end

out.M_red=M1*M2/(M1+M2);
out.M_tot=M1+M2;
out.M_chirp=(out.M_red^3*out.M_tot^2)^(1/5)/(1-ecc^2)^(7/2);

out.G_c3_sol=G_c3_sol;

const=((8*pi)^(8/3)/5)*(G_c3_sol*out.M_chirp)^(5/3);
out.const=const;
out.t=-(1:n)*dt;
out.fr1=1./(-const*out.t).^(3/8);
out.fi1=cumsum(out.fr1)*2*pi*dt;

h=((pi*out.fr1).^(2/3)).*cos(out.fi1);
h=A*h/max(h);
h=h(n:-1:1);
h(n+1:N)=0;
h=gd(h);
out.h=edit_gd(h,'dx',dt,'ini',-DT);
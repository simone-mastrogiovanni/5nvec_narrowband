function [gnoissig,outch]=add_chirp_2(gnois,frs,res,DT,A,t0)
% adds chirp to a gd using chirp_fun_2
%
%   gnois  input gd
%   frs    [frmin fa]
%   res    resolution
%   DT     time from frmin and fa
%   A      amplitude

% Version 2 - October 2018 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 2018  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=dx_gd(gnois);
ini=ini_gd(gnois);
N=n_gd(gnois);

outch=chirp_fun_2(frs,res,DT,A,dt);

y=y_gd(gnois);
y1=y_gd(outch.h);
n=n_gd(outch.h);

N1=floor((t0-DT-ini)/dt)+1;
n1=1;
if N1 < 1
    n1=-N1+1;
end
n2=n;
N2=N1+n-1;
if N2 > N
    n2=n-(N2-N);
    N2=N;
end

y(N1:N2)=y(N1:N2)+y1(n1:n2);

gnoissig=edit_gd(gnois,'y',y);
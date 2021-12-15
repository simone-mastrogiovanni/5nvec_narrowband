function y=limits(x,lmin,lmax)
% limits the values of an array
%
%  lmin   min
%  lmax   max

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=x;

ii=find(x < lmin);
y(ii)=lmin;

if exist('lmax','var')
    ii=find(x > lmax);
    y(ii)=lmax;
end
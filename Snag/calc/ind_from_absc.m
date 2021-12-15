function [ii,err]=ind_from_absc(gin,abscs)
% outputs the indices relative to given abscissas
%
%     [ii,err]=ind_from_absc(gin,abscs)
%
%   gin    input gd
%   abscs  abscissas

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

x=x_gd(gin);
n=length(x);

ii1=interp1(x,1:n,abscs);
ii=round(ii1);
err=ii1-ii;
function [a,d]=galac_disc(n)
%GALAC_DISC galactical disc coordinates
%
%          [a,d]=galac_disc(n)
%
%    n   number of values
%    a   right ascension values (deg)
%    d   declination values (deg)

% Version 2.0 - May 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

in=zeros(n,2);
in(:,1)=((0:n-1)*360/n)';
out=coco(in,'g','j2000.0','d','d');
a=out(:,1);
ii=find(a<0);
a(ii)=a(ii)+360;
d=out(:,2);
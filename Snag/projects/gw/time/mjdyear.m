function m=mjdyear(year)
%MJDYEAR  the mjd of the beginning of the year
%  
%  year    year (int)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

year=round(year);
m=v2mjd([year 1 1 0 0 0]);
function A=smooth_peaks(i,j,z,tim,inifr,dfr,rest,resf)
% SMOOTH_PEAK  smooths a peak map (read by show_peaks)
%
%   A=smooth_peaks(i,j,z,tim,inifr,dfr,rest,resf)
%
%  x,y,z,tim  output of show_peaks
%  rest       resolution reduction in time in sampling units (def 10)
%  resf       resolution enhancement in frequency in sampling units (def 10)
%
%  A          output gd2

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome



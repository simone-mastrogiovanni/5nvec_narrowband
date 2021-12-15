function out=bsd_orthoband_gen(bandin,dt0,Nfft0)
% search orthoband for given band, sampling time and Nfft
%
%   bandin   input band
%   dt0      base sampling time
%   Nfft0    length of the ffts (number of frequencies)
%
%       base orthobands
%  b1   
%     db 1 2 3 4 5 6 7 8 9...
%  0     * * * * * * * * * * * *
%  1     *
%  2     * *
%  3     *   *
%  4     * *   *
%  5     *       *
%  6     * * *     *
%  7     *           *
%  8     * *   *       *
%  9     *   *           *
% 10     * *     *         *
% 11     *                   *
% 12     * * * *    *          *

% Snag Version 2.0 - August 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

band1=floor(bandin*dt0);
band2=floor(bandin*dt0);
Nband0=band2-band1+1;
out.Nband0=Nband0;
base_band=1/dt0;
Nband=Nband0;
bandw=(Nband*base_band);
 
 while 
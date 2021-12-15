function s=gd_ener(varargin)
%ANALYSIS\GD_ENER  energy spectrum estimation
%
% Uses gd_pows
%
% the first argument is the gd
% the use is by the length or the number of pieces
%
% keys:
%   'pieces'
%   'resolution' default=1
%   'length' should be a divisible by 4
%   'nobias'
%   'window' (0 -> no, 1 -> bartlett, 2 -> hanning)
%   'interactive'
%   'short' only half spectrum for real data spectra

% Version 2.0 - October 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

g=varargin{1};
capt=capt_gd(g);
dt=dx_gd(g)*n_gd(g);

s=gd_pows(g,varargin{2:nargin});

s=s*dt;

s=edit_gd(s,'capt',['energy spectrum of:' capt]);
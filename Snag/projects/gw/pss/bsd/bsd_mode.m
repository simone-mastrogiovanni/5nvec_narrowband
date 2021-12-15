function mod=bsd_mode(typ)
% model of mode function
%
%   typ    type number

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('typ','var')
    typ=1;
end
  
mod.comp='normal';  % computing mode ('normal','mex','parallel')
mod.peak_mode=2;

mod.hm.mode=1;         % hm mode (1 standard)
mod.hm.oper='noiseadapt';   % hough operative mode

if mod.hm.mode ~= 1
%     mod.hm.fr(1)=;
%     mod.hm.fr(2)=;
%     mod.hm.fr(3)=;
%     mod.hm.fr(4)=;
%     mod.hm.sd(1)=;
%     mod.hm.sd(2)=;
%     mod.hm.sd(3)=;
end

mod.fu.fftgain=10;     % fft fu enlargement
mod.fu.thr=5;          % fu threshold for peaks
mod.fu.rspot=2;        % fu spot radius (deg)
mod.fu.nfr=3;          % fu coarse frequency steps
mod.fu.nsd=2;          % fu coarse spin-down steps
mod.fu.nsky=1;         % fu coarse rough sky bins
mod.fu.skyres=1;       % fu coarse rough sky bins
mod.fu.ncand=3;        % number of candidates

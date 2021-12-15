function tfstr=bsd_peakmap(in,lfft,thr,typ)
% peakmap creation
%
%      tfstr=bsd_peakmap(in,lfft,thr,typ)
%
%    in     input bsd
%    lfft   length of the ffts (possibly enhanced, multiple of 4)
%    thr    normalized threshold
%    typ    type structure

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('thr')
    thr=2.5;
end

if ~exist('typ','var')
    typ.sstype='median'; % very short spectrum type
    typ.ssred=256; % reduction factor for very short spectrum
    typ.minno0=0.5;
end

tfstr=bsd_peakmap_cell(in,lfft,thr,typ);
tfstr.peaktype='array';

peaks=bsd_peakmap_conv(tfstr);
tfstr.pt.peaks=peaks;
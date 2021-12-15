function [d,source,data]=ps_chunk(source,antenna,data,doptab)
%PS_CHUNK  produce a chunk of data from a set of periodic sources
%
%  ATTENTION ! inside the chunk the frequency and amplitude are constant
%
%   source(i)        array of periodic source structures
%           .a       a or l of the source [deg]
%           .d       d or b of the source [deg]
%           .psi     polarization angle [deg]
%           .eps     percentage of linear polarization
%           .t00     f0 epoch (mjd)
%           .f0      frequency of the source at time t00
%           .df0     first derivative of the frequency
%           .ddf0    second derivative of the frequency
%           .h       amplitude
%           .snr     signal-to-noise ratio (power, ref. to short spectra)
%           .coord   = 0 -> equatorial, 1 -> ecliptic
%           .chphase phase of the last data of the preceding chunk 
%
%   antenna          detector structure       
%          .long     detector longitude [deg]
%          .lat      detector latitude [deg]
%          .azim     detector azimuth [deg]
%          .incl     detector inclination [deg]
%          .type     1 - bar, 2 - interferometer
%
%   data             requested data structure
%       .n           chunk length
%       .dt          sampling time
%       .t0          starting time (mjd; for amplitude and frequency)
%       .t           time of the first data of the chunk (mjd) d)
%
%     d    output chunk
%
%   The amplitude, frequency and phase are computed only at the beginning
%   of the chunk.
%   It uses gw_Doppler and gw_radpat.

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

N=length(source);
n=data.n;
d=zeros(1,n);
%t0=mjd2tai(data.t0);
t=mjd2tai(data.t);
[v_det(1),v_det(2),v_det(3)]=v_detector(doptab,t);
nn=1:n;

for i = 1:N
    fr=source(i).f0+source(i).df0*(t-source(i).t00)+source(i).ddf0*(t-source(i).t00)^2/2; % DA CORREGGERE SUL SIGNIFICATO DI t0
    fr=fr*gw_doppler1(v_det,source(i));
    ph0=source(i).chphase;
    ph1=(data.dt*fr*2*pi);
    ph=ph0+nn*ph1; % lungo 3
    %ph=mod(ph,2*pi); % lungo 1
    amp=sqrt(gw_radpat(antenna,source(i),t))*source(i).h;
    d=d+amp*sin(ph); % lungo 2
    source(i).chphase=mod(ph(n),2*pi);
end

data.t=tai2mjd((t*86400+data.dt*data.n./data.type)/86400);
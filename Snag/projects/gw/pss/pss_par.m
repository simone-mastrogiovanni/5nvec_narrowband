function p=pss_par(varargin)
%PSS_PAR   computes parameters for PSS
%
%    p=pss_par(varargin)
%
%    p             output pss parameter structure
%
%    varargin{1}   could be an input pss parameter structure
%
%    keys:
%
%    'init'        initialize the structure with the default input parameters
%
%
%  PSS_PAR structure (0 fixed, 1 input, 2 derived, 3 analysis results):
%
%  0  p.phys.c        light velocity
%  0  p.phys.G        gravitational constant
%  0  p.phys.deg2rad  conversion factor from degrees to radiants
%  0  p.phys.Eorbv    Earth mean orbital velocity
%  0  p.phys.Erotv    Earth rotational velocity
%
%  1  p.antenna.long    detector longitude [deg]
%  1  p.antenna.lat     detector latitude [deg]
%  1  p.antenna.azim    detector azimuth  (from south to west) [deg]
%  1  p.antenna.incl    detector inclination [deg]
%  1  p.antenna.type     1 - bar, 2 - interferometer
%  
%     p.antenna.bar.fixed   
%     p.antenna.bar.var
%
%     p.antenna.itf.fixed
%     p.antenna.itf.var
%
%  1  p.source.name    source name
%  1  p.source.a       a or l of the source
%  1  p.source.d       d or b of the source
%  1  p.source.eps     percentage of linear polarization
%  1  p.source.psi     polarization angle [deg]
%  1  p.source.t00     frequency epoch (tipically v2mjd([2000,1,1,0,0,0]))
%  1  p.source.f0      frequency of the source
%  1  p.source.df0     first derivative of the frequency
%  1  p.source.ddf0    second derivative of the frequency
%  1  p.source.h       amplitude
%  1  p.source.snr     signal-to-noise ratio (power, ref. to short spectra)
%  1  p.source.coord   = 0 -> equatorial, 1 -> ecliptic
%
%  1  p.data.dt       sampling time
%  2  p.data.sf       sampling frequency
%  1  p.data.tobs     total observation time (days)
%     p.tin           initial time (mjd)
%  1  p.data.tinstr   initial time (Matlab datevec vector)
%  2  p.data.tnum     initial time (numtim)
%
%  1  p.fft.len       fft length (number of samples)
%  2  p.fft.tlen      fft time length
%  2  p.fft.N         number of ffts
%  1  p.fft.onev      take one fft every...
%  2  p.fft.df        frequency bin
%
%  1  p.tfmap.thr       threshold for the peaks
%  1  p.tfmap.gd2name   name of the gd2 object
%  1  p.tfmap.capt      caption
%  3  p.tfmap.npeaktot  total number of peaks in the tfmap
%
%  1  p.band.Bf1      initial frequency of the full band
%  2  p.band.Bf2      final frequency of the full band
%  2  p.band.f0       supposed initial unshifted frequency
%  1  p.band.df0      f0 first derivative
%  1  p.band.ddf0     f0 second derivative
%  1  p.band.errf0    (band.f0-source.f0)/fft.df
%  2  p.band.natb     "natural" sub-band (working band)
%  1  p.band.knatb    widening factor of natural sub-band
%  2  p.band.bf1      sub-band initial frequency
%  2  p.band.bf2      sub-band final frequency
%
%  1  p.hmap.type      0 -> equatorial, 1 -> ecliptical
%  1  p.hmap.mode      'rectangular', 'trmap' 
%  1  p.hmap.gd2name   name of the gd2 object
%  1  p.hmap.trmname   name of the trmap object
%  1  p.hmap.da        right ascension or lambda resolution [deg]
%                       (choose such as na is integer)
%  1  p.hmap.dd        declination or b resolution [deg]
%                       (choose such as nd is integer)
%  1  p.hmap.a1        initial a coordinate [deg]
%  1  p.hmap.a2        final a coordinate [deg]
%  1  p.hmap.d1        initial d coordinate [deg]
%  1  p.hmap.d2        final d coordinate [deg]
%  2  p.hmap.na        number of a coordinate values
%  2  p.hmap.nd        number of d coordinate values
%  2  p.hmap.stres     standard resolution (on a)
%  1  p.hmap.restria   resolution of triangle map (multiple of stres)
%  2  p.hmap.ntria     number of triangles
%  1  p.hmap.Df0       f0 step
%  1  p.hmap.f01       initial f0
%  1  p.hmap.f02       final f0
%  2  p.hmap.nf0       number of f0 steps
%  1  p.hmap.Ddf0      df0 step
%  1  p.hmap.df01      initial df0
%  1  p.hmap.df02      final df0
%  2  p.hmap.ndf0      number of df0 steps
%  1  p.hmap.Dddf0     ddf0 step
%  1  p.hmap.ddf01     initial ddf0
%  1  p.hmap.ddf02     final ddf0
%  2  p.hmap.nddf0     number of ddf0 steps
%
%  1  p.mapping.type  mapping type ('univocal','overlapped','proportional',...)
%??  1  p.mapping.kdf   semi-width of the frequency interval (in units of df)
%
%  1  p.comp.method   algorithm (the name)
%  2  p.comp.gflops   gigaflops needed
%  2  p.comp.gbytes   gigabytes needed
%
%     p.lut   is defined in pss_crea_lut  

% Version 1.0 - Sep 1999-2003
% Snag Application 
% by Sergio Frasca - sergio.frasca@roma1.infn.it
%      Department of Physics - Universita` "La Sapienza" - Rome
%     Maria Alessandra Papa - papa@aei-potsdam.mpg.de
%      Max-Planck-Institut für Gravitationsphysik - Potsdam


ini=1;
if isstruct(varargin{1})
   p=varargin{1};
   ini=2;
end

for i = ini:length(varargin)
   str=varargin{i};
   switch str
   case 'init'
      p.phys.c=2.99792458*10^8;
      p.phys.G=6.67259*10^-11;
      p.phys.deg2rad=0.0174532925199433;
      p.phys.Evorb=29785;
      p.phys.Evrot=463.8336;
      
      p.antenna.long=10;
      p.antenna.lat=45;
      p.antenna.azim=0;
      p.antenna.incl=0;
      p.antenna.type=2;
      
      p.source.name='Xxxxx';
      p.source.a=120;
      p.source.d=30;
      p.source.eps=1;
      p.source.psi=0;
      p.source.t00=v2mjd([2000,1,1,0,0,0]);
      p.source.f0=100;
      p.source.df0=0;
      p.source.ddf0=0;
      p.source.snr=1;
      
      p.data.dt=1/400;
      p.data.tobs=365.25;
      p.data.tinit=[2000,1,1,0,0,0];
      
      p.fft.len=2^22;
      p.fft.onev=10;
      
      p.tfmap.thr=6;
      p.tfmap.gd2name='peakmap';
      p.tfmap.capt='Spectral Peak Map';
      p.tfmap.npeaktot=-1;
      
      p.band.Bf1=0;
      p.band.df0=0;  % coeff. first deriv.
      p.band.ddf0=0;  % coeff. second deriv.
      p.band.errf0=0;
      p.band.knatb=1.1;
      
      p.hmap.type=1;
      p.hmap.mode='rectangular';
      p.hmap.gd2name='hmap';
      p.hmap.trmname='trmap';
      p.hmap.da=1;
      p.hmap.dd=1;
      p.hmap.a1=0;
      p.hmap.a2=360.
      p.hmap.d1=-90;
      p.hmap.d2=90;
      p.hmap.restria=1;
      p.hmap.Df0=1;
      p.hmap.f01=300;
      p.hmap.f02=300;
      p.hmap.Ddf0=1;
      p.hmap.df01=0;
      p.hmap.df02=0;
      p.hmap.Dddf0=1;
      p.hmap.ddf01=0;
      p.hmap.ddf02=0;
      
      p.mapping.type='overlapped';
      p.mapping.kdf=0.5;
      
      p.comp.method='standard';
   end
end

p.data.sf=1/p.data.dt;  p.data.tinit
p.data.tnum=datenum(p.data.tinit(1),p.data.tinit(2),p.data.tinit(3),...
   p.data.tinit(4),p.data.tinit(5),p.data.tinit(6));

p.fft.tlen=p.data.dt*p.fft.len;
p.fft.N=ceil(p.data.tobs*2*86400/(p.fft.tlen*p.fft.onev)); % interlaced data
p.fft.df=1/p.fft.tlen;

p.band.Bf2=p.band.Bf1+p.data.sf/2;
p.band.f0=p.source.f0+p.band.errf0*p.fft.df;
p.band.natb=p.band.f0*2*(p.phys.Evorb+p.phys.Evorb*...
    cos(p.phys.deg2rad*p.antenna.lat))/p.phys.c;
%p.band.bf1=p.band.f0-p.band.natb*p.band.knatb/2;
%p.band.bf2=p.band.f0+p.band.natb*p.band.knatb/2;

nfbin=ceil(p.band.natb*p.band.knatb/(2*p.fft.df))
p.band.bf1=p.band.f0-nfbin*p.fft.df;
p.band.bf2=p.band.f0+nfbin*p.fft.df;

p.hmap.na=round((p.hmap.a2-p.hmap.a1)/p.hmap.da);
p.hmap.nd=round((p.hmap.d2-p.hmap.d1)/p.hmap.dd);
p.hmap.stres=1; %da fare
p.hmap.nf0=round((p.hmap.f02-p.hmap.f01)/p.hmap.Df0)+1;
p.hmap.ndf0=round((p.hmap.df02-p.hmap.df01)/p.hmap.Ddf0)+1;
p.hmap.nddf0=round((p.hmap.ddf02-p.hmap.ddf01)/p.hmap.Dddf0)+1;

p.comp.gflops=1; %da fare
p.comp.gbytes=1; %da fare
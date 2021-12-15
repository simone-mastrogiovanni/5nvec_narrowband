function sim_sds0(sim_str,fdb_str)
%SIM_SDS  creates one or more simulated sds data files
%
%  sim_str  simulation structure
%       type     = 0 stationary, 1 non-stationary
%       nss      non-stationarity structure (if type=1)
%       ant      antenna structure (only for signal simulation)
%       sour     source structure (only for signal simulation)
%       lfft     fft length for simulation
%       t0       initial time (mjd)
%       dt       sampling time (s)
%
%  fdb_str  files database structure
%       folder   database folder
%       head     filename header (p.es. 'VIR_hrec_')
%       tail     filename tail (p.es. '_crab')
%       ndat     total number of data
%       fndat    number of data per file
%
% All the basic structures pertaining the PSS project are defined in the PSS_UG

% Version 2.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

l=sim_str.lfft/2;
buff=zeros(1,3*(l/2));

t0=sim_str.t0;
dt=sim_str.dt;

sigsim=0;
    
d=ds(l);
d=edit_ds(d,'dt',dt,'type',1);

frcomb=300;
ampcomb=1;
combw=1;
gs=gd_drawspect(dt,l*2,'virgo','addcomb',combw,frcomb,ampcomb);
sp=y_gd(gs);

sds_.nch=1;
sds_.len=0;
sds_.t0=0;
sds_.dt=dt;
sds_.capt='gw antenna simulation';
sds_.ch{1}='hrec';

filename=['SIM_hrec',mjd2_d_t(t0),'.sds'];
file=[fdb_str.folder,filename];
sds_=sds_openw(file,sds_);

i=0;
ii=0;
t=t0;

while i < fdb_str.ndat
   [d,buff]=noise_ds(d,buff,'spect',sp);
   dd=y1_ds(d);
   i=i+l;
   ii=ii+l;
   fwrite(sds_.fid,dd,'float32');
   if ii > fdb_str.fndat
       t0=t0+dt*(ii-1)/86400;
       ii=0;
       fclose(sds_.fid);
       
        filename=['SIM_hrec',mjd2_d_t(t0),'.sds']
        file=[fdb_str.folder,filename];
        sds_=sds_openw(file,sds_);
   end
end

fclose(sds_.fid);

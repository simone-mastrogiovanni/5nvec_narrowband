function sim_sds(sim_str,fdb_str,doptab)
%SIM_SDS  creates one or more simulated sds data files
%
%  sim_str  simulation structure
%       type     = 0 stationary, 1 non-stationary
%       nss      non-stationarity structure (if type=1)
%       ant      antenna structure (only for signal simulation)
%       sour     source structure (only for signal simulation)
%       lfft     fft length for simulation
%       spec     noise spectrum (gd, if pre-defined)
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

if isfield(sim_str,'spec')
    sim_str.lfft=n_gd(sim_str.spec);
    sim_str.dt=1/(n_gd(sim_str.spec)*dx_gd(sim_str.spec));
end
disp(sim_str)
disp(fdb_str)

len=sim_str.lfft/2;
buff=zeros(1,3*(len/2));

t0=sim_str.t0;
dt=sim_str.dt;

sigsim=0;

if isfield(sim_str,'sour')
    sigsim=1
    sources=sim_str.sour;
    antenna=sim_str.ant;
    data.n=sim_str.lfft/2;
    data.dt=sim_str.dt;
    data.t0=sim_str.t0;
    data.t=sim_str.t0;
    data.type=1;
end
    
d=ds(len);
d=edit_ds(d,'dt',dt,'type',1);

if isfield(sim_str,'spec')
    combw=0;
    sp=sim_str.spec;
else
    frcomb=(1:20)*100;
    ampcomb=zeros(1,20);
    combw=1;
    gs=gd_drawspect(dt,len*2,'virgo','addcomb',combw,frcomb,ampcomb);
    sp=y_gd(gs);
end

sds_.nch=1;
sds_.len=0;
sds_.t0=sim_str.t0;
sds_.dt=dt;
sds_.capt='gw_antenna_simulation';
sds_.ch{1}='hrec';

filename=['SIM_hrec',mjd2_d_t(t0),'.sds'];
file=[fdb_str.folder,filename];
sds_=sds_openw(file,sds_);

i=0;
ii=0;
t=t0;

while i < fdb_str.ndat
   [d,buff]=noise_ds(d,buff,'spect',sp); % display_ds(d),std(y_ds(d))
   dd=y1_ds(d);
   if sigsim > 0
       [ps,sources,data]=ps_chunk(sources,antenna,data,doptab);%size(dd),size(ps)
       dd=dd+ps';
   end
   i=i+len;
   ii=ii+len;
   fwrite(sds_.fid,dd,'float32');
   if ii > fdb_str.fndat
       t=t+dt*(ii-1)/86400;
       ii=0;
       fclose(sds_.fid);
       
       sds_.t0=t;
       filename=['SIM_hrec',mjd2_d_t(t),'.sds']
       file=[fdb_str.folder,filename];
       sds_=sds_openw(file,sds_);
   end
end

fclose(sds_.fid);

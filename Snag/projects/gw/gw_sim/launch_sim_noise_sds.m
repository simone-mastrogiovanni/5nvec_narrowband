%  launch_sim_noise_sds
%
%  sim_str  simulation structure
%       type     = 0 stationary, 1 non-stationary
%       nss      non-stationarity structure (if type=1)
%       ant      antenna structure (only for for signal simulation)
%       sour     source structure (only for for signal simulation)
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

clear sim_str
sim_str.type=0;
sim_str.lfft=16344*16;
sim_str.t0=53371;
sim_str.dt=0.00025;

fdb_str.folder='C:\appo\sds\';
fdb_str.head='SIM_hrec';
fdb_str.tail='';
fdb_str.ndat=100000000;
fdb_str.fndat=10000000;

sim_sds(sim_str,fdb_str)
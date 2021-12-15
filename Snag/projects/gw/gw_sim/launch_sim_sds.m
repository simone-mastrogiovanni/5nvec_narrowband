%  launch_sim_sds
%
% Create the "doptab", then run this.
% Attention to the array structure "sources" (create by
%   crea_pssource0)
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

sim_str.type=0;
sim_str.lfft=16384*8;
sim_str.t0=53371;
sim_str.dt=0.00025;

N=10;
%sources=crea_pssource0(N,1.e-21,1000);
sources=crea_pssource0(N,1.e-21,1000);
sim_str.sour=sources;
sim_str.ant.azim=0;
sim_str.ant.incl=0;
sim_str.ant.type=2;
sim_str.ant.lat=43.67;
sim_str.ant.long=10.5;

source_tab(sources);

fdb_str.folder='C:\appo\sds\';
fdb_str.head='SIM_hrec';
fdb_str.tail='';
fdb_str.ndat=100000000;
fdb_str.fndat=10000000;

sim_sds(sim_str,fdb_str,doptab)
%  launch_realsim_sds
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
%       lchunk   chunk length for simulation
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
sim_str.lchunk=100000;

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

sds_in=selfile(' ');

fileout=realsim_sds(sds_in,1,sim_str,fdb_str,doptab,'')
% driver_sim_sds
%
%  define sim_case !

load virgo_070905_L

sim_str.type=0;
sim_str.spec=virgo_070905_L;
sim_str.t0=54348;

fdb_str.ndat=100000000;
fdb_str.folder='';
fdb_str.fndat=20000000;

sim_sds(sim_str,fdb_str)

% driver_sim_sds1
%
%  define sim_case !

% load virgo_070905_L
% sp1=virgo_070905_L

%vv=tdwin(virgo_070905_L,'hhole')

sim_str.type=0;
sim_str.spec=sp1;
sim_str.t0=54348;

fdb_str.ndat=100000000;
fdb_str.folder='';
fdb_str.fndat=20000000;

sim_sds(sim_str,fdb_str)

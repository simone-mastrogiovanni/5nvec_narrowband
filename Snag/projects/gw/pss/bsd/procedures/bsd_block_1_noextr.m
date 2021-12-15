% bsd_block_1_noextr
%
% extracts data to analyze
%   needs bsd_out
%   produces bsd_out,BSD_tab_out,stpar
%
% bsd_block procedures: copy the script in the work folder
%  with different name and modify
% do not modify original block

SD=86164.09053083288;

cont=cont_gd(bsd_out);
T0=cont.t0;
dt=dx_gd(bsd_out);
n=n_gd(bsd_out);
Tobs=n*dt;

dsd0=1/Tobs^2; dsd=dsd0
target=new_posfr(target,T0);

frdec=target.f0;
freq1=[frdec-5.1/SD,frdec+5.1/SD];
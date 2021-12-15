% dyna_driver

 param.To=200;
 param.dt=0.01;
 param.beta=0;
 param.beta=0.1;
 param.k=2;
 param.m=1;
%  param.muv=0.5;
 param.muv=0;
 param.A=10;
 param.x0=10;
 param.v0=0;
 
in.fr=0;
check=3;
out=dyna_sim(param,in,check);
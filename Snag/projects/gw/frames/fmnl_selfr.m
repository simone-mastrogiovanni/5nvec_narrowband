function [chs,chn,dt,dlen,sp]=fmnl_selfr(file)

vers=fmnl_chkver(file);
if vers <= 3
   [chs,chn,dt,dlen,sp]=
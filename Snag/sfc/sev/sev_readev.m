function [vd,vi,vf,stat,ar]=sev_readev(sev_)
% SEV_READEV  reads an event

c4=0;
[vd c1]=fread(sev_.fid,sev_.nd,'double');
[vi c2]=fread(sev_.fid,sev_.ni,'int32');
[vf c3]=fread(sev_.fid,sev_.nf,'float');
if sev_.lar > 0
    [ar c4]=fread(sev_.fid,sev_.lar,'float');
end

stat=c1+c2+c3+c4;
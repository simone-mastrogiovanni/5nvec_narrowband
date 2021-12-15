function sev_writev(sev_,vd,vi,vf,ar)
% SEV_WRITEV  writes an event
%

fwrite(sev_.fid,vd,'double');
vi=fwrite(sev_.fid,vi,'int32');
vd=fwrite(sev_.fid,vf,'float');
if sev_.lar > 0
    vd=fwrite(sev_.fid,ar,'float');
end

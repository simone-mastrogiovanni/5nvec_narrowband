function doptab2sds(doptab,sdsfile,capt)
%DOPTAB2SDS  writes a doppler table 'doptab' to an sds file

[ni,nj]=size(doptab);
dt=(doptab(1,nj)-doptab(1,1))*86400/(nj-1);
t0=doptab(1,1);

sds.nch=7;
sds.len=nj;
sds.t0=t0;
sds.dt=dt;
sds.capt=['Doppler Table - time in tdt - ' capt];
sds.ch{1}='p_x';
sds.ch{2}='p_y';
sds.ch{3}='p_z';
sds.ch{4}='v_x';
sds.ch{5}='v_y';
sds.ch{6}='v_z';
sds.ch{7}='Einstein correction';

sds=sds_openw(sdsfile,sds);

for i = 1:nj
    fwrite(sds.fid,doptab(2:8,i),'float');
end

fclose(sds.fid);
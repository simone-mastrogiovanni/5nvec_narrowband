function doptab2sds_old(doptab,sdsfile,capt)
%DOPTAB2SDS  writes a doppler table 'doptab' to an sds file

[ni,nj]=size(doptab);
dt=(doptab(1,nj)-doptab(1,1))*86400/(nj-1);
t0=doptab(1,1);

sds.nch=4;
sds.len=ni;
sds.t0=t0;
sds.dt=dt;
sds.capt=['Doppler Table - time in tdt' capt];
sds.ch{1}='v_x';
sds.ch{2}='v_y';
sds.ch{3}='v_z';
sds.ch{4}='Einstein correction';

sds=sds_openw(sdsfile,sds);

for i = 1:ni
    fwrite(sds.fid,doptab(i,2:5),'float');
end

fclose(sds.fid);
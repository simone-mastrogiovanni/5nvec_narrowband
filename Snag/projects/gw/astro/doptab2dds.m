function doptab2dds(doptab,ddsfile,capt)
%DOPTAB2dds  writes a doppler table 'doptab' to an dds file

[ni,nj]=size(doptab);
dt=(doptab(1,nj)-doptab(1,1))*86400/(nj-1);
t0=doptab(1,1);

dds.nch=7;
dds.len=nj;
dds.t0=t0;
dds.dt=dt;
dds.capt=['Doppler Table - time in tdt - ' capt];
dds.ch{1}='p_x';
dds.ch{2}='p_y';
dds.ch{3}='p_z';
dds.ch{4}='v_x';
dds.ch{5}='v_y';
dds.ch{6}='v_z';
dds.ch{7}='Einstein correction';

dds=dds_openw(ddsfile,dds);

for i = 1:nj
    fwrite(dds.fid,doptab(2:8,i),'double');
end

fclose(dds.fid);
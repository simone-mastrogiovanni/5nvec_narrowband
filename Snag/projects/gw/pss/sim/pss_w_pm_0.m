function pss_w_pm_0(pm,file)
%PSS_W_PM_0  writes a peak map in easy format

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen(file,'w');

fwrite(fid,pm.np,'int32');
fwrite(fid,pm.nfr,'int32');
fwrite(fid,pm.lfft,'int32');
fwrite(fid,pm.win,'int32');

fwrite(fid,pm.frin,'float32');
fwrite(fid,pm.dfr,'float32');
fwrite(fid,pm.t0,'float32');
fwrite(fid,pm.dt,'float32');
fwrite(fid,pm.res,'float32');
fwrite(fid,pm.thresh,'float32');

% [i1,j1]=find(pm.PM);
% n1=length(i1);

for i = 1:pm.np
    fwrite(fid,pm.t(i),'float32');
	fwrite(fid,pm.v(i,1),'float32');
	fwrite(fid,pm.v(i,2),'float32');
	fwrite(fid,pm.v(i,3),'float32');
    fwrite(fid,pm.st(i),'float32');
    fwrite(fid,pm.nois(i),'float32');
    a=pm.PM(:,i);
    [i1,j1]=find(a);
    n1=length(i1);
    fwrite(fid,n1,'int32');
    fwrite(fid,i1,'int32'); % all the array
end

fclose(fid);
    



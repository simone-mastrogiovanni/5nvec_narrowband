function sds_writegd(folder,file,gd)
%SDS_WRITEGD  writes a gd in an sds file
%
% for a better function, use gd2sds

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sds_.nch=1;
sds_.len=n_gd(gd);
sds_.t0=ini_gd(gd);
sds_.dt=dx_gd(gd);
sds_.capt=capt_gd(gd);
sds_.ch{1}=capt_gd(gd);

sds_=sds_openw(strcat(folder,file),sds_);

fwrite(sds_.fid,y_gd(gd),'float');

fclose(sds_.fid);
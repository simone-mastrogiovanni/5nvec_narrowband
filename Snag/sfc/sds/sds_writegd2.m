function sds_writegd2(folder,file,gd2)
%SDS_WRITEGD2  writes a gd2 in an sds file

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

m=m_gd2(gd2);
sds_.len=n_gd2(gd2);
sds_.nch=sds_.len/m;
sds_.t0=ini_gd2(gd2);
sds_.dt=dx_gd2(gd2);
sds_.capt=capt_gd2(gd2);

for i = 1:sds_.nch
    sds_.ch{i}=[capt_gd2(gd2) ' ' num2str(i)];
end

sds_=sds_openw(strcat(folder,file),sds_);
gd2=y_gd2(gd2);

fwrite(sds_.fid,gd2(:),'float');

fclose(sds_.fid);
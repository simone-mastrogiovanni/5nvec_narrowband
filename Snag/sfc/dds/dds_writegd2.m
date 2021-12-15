function dds_writegd2(folder,file,gd2)
%dds_WRITEGD2  writes a gd2 in an dds file

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

m=m_gd2(gd2);
dds_.len=n_gd2(gd2);
dds_.nch=dds_.len/m;
dds_.t0=ini_gd2(gd2);
dds_.dt=dx_gd2(gd2);
dds_.capt=capt_gd2(gd2);

for i = 1:dds_.nch
    dds_.ch{i}=[capt_gd2(gd2) ' ' num2str(i)];
end

dds_=dds_openw(strcat(folder,file),dds_);
gd2=y_gd2(gd2);

fwrite(dds_.fid,gd2(:),'double');

fclose(dds_.fid);
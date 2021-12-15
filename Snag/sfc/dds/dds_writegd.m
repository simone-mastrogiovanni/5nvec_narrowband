function dds_writegd(folder,file,gd)
%dds_WRITEGD  writes a gd in an dds file

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dds_.nch=1;
dds_.len=n_gd(gd);
dds_.t0=ini_gd(gd);
dds_.dt=dx_gd(gd);
dds_.capt=capt_gd(gd);
dds_.ch{1}=capt_gd(gd);

dds_=dds_openw(strcat(folder,file),dds_);

fwrite(dds_.fid,y_gd(gd),'double');

fclose(dds_.fid);
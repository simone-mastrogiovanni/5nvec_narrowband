function [chss,ndatatot,fsamp,t0,t0gps]=sds_getchinfo(file)
%SDS_GETCHINFO   gets the channel names in a file, from the first frame
%
%      [chss,ndatatot,fsamp,t0]=sds_getchinfo(file)
%
%      file   ...
%      chss   cell array with the names of the channels
%      ndata  total number of data
%      fsamp  sampling frequency
%      t0gps     gps time (seconds)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sds_=sds_open(file);

chss=sds_.ch;
ndatatot=sds_.len;
fsamp=1/sds_.dt;
% t0gps=sds_.t0;
% t0=gps2mjd(t0gps);
t0=sds_.t0;
t0gps=mjd2gps(t0);
mjd2s(t0)
fclose(sds_.fid);
disp(['open-close ' file 'file'])
function [chss,ndatatot,fsamp,t0,t0gps]=dds_getchinfo(file)
%dds_GETCHINFO   gets the channel names in a file, from the first frame
%
%      [chss,ndatatot,fsamp,t0]=dds_getchinfo(file)
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

dds_=dds_open(file);

chss=dds_.ch;
ndatatot=dds_.len;
fsamp=1/dds_.dt;
t0gps=dds_.t0;
t0=gps2mjd(t0gps);
mjd2s(t0)
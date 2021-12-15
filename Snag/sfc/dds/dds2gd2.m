function g=dds2gd2(file)
%dds2GD2  creates a gd2 with the data of an dds file
%
%   file    input file

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dds_=dds_open(file);

A=fread(dds_.fid,[dds_.nch,dds_.len],'double');

g=gd2(A);

g=edit_gd2(g,'ini',dds_.t0,'dx',dds_.dt,'capt',dds_.capt);

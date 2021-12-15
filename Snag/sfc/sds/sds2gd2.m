function g=sds2gd2(file)
%SDS2GD2  creates a gd2 with the data of an sds file
%
%   file    input file

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

sds_=sds_open(file);

A=fread(sds_.fid,[sds_.nch,sds_.len],'float');

g=gd2(A);

g=edit_gd2(g,'ini',sds_.t0,'dx',sds_.dt,'capt',sds_.capt);

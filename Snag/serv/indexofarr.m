function i=indexofarr(arr,val)
%INDEXOFARR  finds the index of an array nearest to a certain value
%
%   arr   the array
%   val   the value
%
%    i    the index

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

arr=abs(arr-val);

[a,i]=min(arr);

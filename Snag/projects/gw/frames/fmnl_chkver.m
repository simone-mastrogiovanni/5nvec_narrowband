function [vers,minvers]=fmnl_chkver(file)

% [vers,minvers]=fmnl_chkver(file)
%                             
%                Check Frame Format version
%                            ver = version
%                         minver =minor version number
%

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[fid,message]=fopen(file,'r');

if fid < 0
   disp([file ' <->' message]);
end

igwd=fread(fid,4,'uchar');
igwd=char(igwd)';

if strcmp(igwd,'IGWD') == 0
disp('This is not a frame file');
end

fseek(fid,1,'cof');
vers=fread(fid,1,'uchar');
minvers=fread(fid,1,'uchar');
% fprintf('Data Frame Format version %d.%d \n',vers,minvers);

function [file,pnam]=path_from_file(file)
%PATH_FROM_FILE  extracts the path and the filename from a path+filename string
%

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nfile=double(file);
lastsl=0;
len=length(file);

for i = 1:len
    if nfile(i) == 47 | nfile(i) == 92
        lastsl=i;
    end
end

pnam=char(file(1:lastsl));
file=char(file(lastsl+1:len));
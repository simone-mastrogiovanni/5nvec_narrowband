function g=jpg2gd2(file,nogd)
%JPG2GD2
%
%  file   jpeg file (0 -> opens file reading window
%
%  nogd   =1 exit on matrix

% Version 2.0 - September 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isnumeric(file)
    [fnam,pnam]=uigetfile('*.*','File Selection');
    file=strcat(pnam,fnam);
end

g=imread(file);
g=double(g);
% Makefile for FRDECOMP Mex-File
%
% This M-file assumes that zlib source files exist in (snagdirectory)\frames\zlib.
%
% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


compiledir=fullfile(matlabroot,'sys','lcc','bin');
framedir=fullfile(snagdir,'frames');  % Frames file Directory   
zlibdir=fullfile(framedir,'zlib');    % Zlib files directory

wd=cd;                                % Remembers current working directory
cd(matlabroot);

fprintf('Frames directory: %s\n',framedir);
fprintf('Zlib directory: %s\n',zlibdir);
fprintf('Working Directory: %s\n',wd);

cd(compiledir);
file_copied1 = copyfile('lcclib.exe',zlibdir);
cd(framedir);
file_copied2 = copyfile('frdecomp.c',zlibdir);

if file_copied2 == 1 & file_copied2 == 1

cd(zlibdir);

% Compile necessary zlib source files 

mex -c adler32.c zlib.h zconf.h;
mex -c compress.c zlib.h zconf.h;
mex -c crc32.c zlib.h zconf.h;
mex -c deflate.c deflate.h zutil.h zlib.h zconf.h;
mex -c gzio.c zutil.h zlib.h zconf.h;
mex -c infblock.c zutil.h zlib.h zconf.h infblock.h inftrees.h infcodes.h infutil.h;
mex -c infcodes.c zutil.h zlib.h zconf.h inftrees.h infutil.h infcodes.h inffast.h;
mex -c inflate.c zutil.h zlib.h zconf.h infblock.h;
mex -c inftrees.c zutil.h zlib.h zconf.h inftrees.h;
mex -c infutil.c zutil.h zlib.h zconf.h inftrees.h infutil.h;
mex -c inffast.c zutil.h zlib.h zconf.h inftrees.h infutil.h inffast.h;
mex -c trees.c deflate.h zutil.h zlib.h zconf.h;
mex -c uncompr.c zlib.h zconf.h;
mex -c zutil.c zutil.h zlib.h zconf.h;

% Create zlib library file

!lcclib /out:zlib.lib *.obj

mex frdecomp.c zlib.lib;
   
delete('lcclib.exe');
delete('zlib.lib');
delete('*.obj');
   
file_copied3 = copyfile('frdecomp.dll',framedir);
delete('frdecomp.c');
delete('frdecomp.dll');
cd(wd);
   
else
   fprintf('Files not moved to %s',zlibdir);
end



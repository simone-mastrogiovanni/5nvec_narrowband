%IREAD_SNF_GD   interactive access to read_snf_gd

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

prompt={'gd or gd2 name ?'};
defa={'?'};
answ=inputdlg(prompt,'Read a SNF data file to a gd or gd2',1,defa);

[fname,pname]= uigetfile([snfdata '*.snf'],'File to read');

clear r_struct;
r_struct.file=[pname fname];

str=['[' answ{1} ',r_struct]=read_snf_gd(r_struct);'];
eval(str);

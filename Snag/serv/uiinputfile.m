%uiinputfile  input from snf file

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[fname,pname] = uigetfile([snfdata '*.snf'],'Select the input SNF file');

r_struct.file=[pname fname];
str=[answnamwgd{1},'=read_snf_gd(r_struct);'];
eval(str);



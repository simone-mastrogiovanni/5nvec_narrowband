%uiinputascii  input from ascii file to a gd

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[fname,pname] = uigetfile('*.*','Select the ascii input file');

prompt={'Number of comment lines to skip ?' ...
      'Number of columns ?' 'Which column ?'};
defa={'0','1','1'};
answ=inputdlg(prompt,'Read an ASCII data file to a gd',1,defa);

file=[pname fname];
ncomments=eval(answ{1});
ncol=eval(answ{2});
col=eval(answ{3});

str=[answnamwgd{1} '=gd(readascii1col(file,ncomments,ncol,col));'];
eval(str);


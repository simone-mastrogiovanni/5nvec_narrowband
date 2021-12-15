%IWRITE_SNF_GD   interactive access to write_snf_gd

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

prompt={'gd or gd2 name ?' ...
      'Format ? (''ascii'' ''int8'' ''int16'' ''log8'' ''log16'' ''float'' ''double'')'};
defa={'?','float'};
answ=inputdlg(prompt,'Save a gd or a gd2 to a SNF data file',1,defa);

gdname=answ{1};
form=answ{2};

[fname,pname]=uiputfile([snfdata '*.snf'],'Output file');
file=[pname fname];

str=['write_snf_gd(' gdname ',''' file ''',''' form ''');'];
eval(str);


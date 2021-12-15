function r_struct=browse_snf
%BROWSE_SNF   browse snf files

% Version 1.0 - May 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;
[fname,pname]= uigetfile([snfdata '*.*'],'File to access');

clear r_struct;
r_struct.file=[pname fname];
r_struct.select={'0'};

[fid,r_struct]=open_snf_read(r_struct);

text=r_s_show(r_struct);

msgbox(text);
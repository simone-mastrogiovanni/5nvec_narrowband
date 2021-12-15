function [out_db,D_B]=go_db(D_B)
%GO_DB  let the data browser go (processing distribution)
%
%          [out_db,D_B]=go_db(D_B)
%
%          D_B        a D_B structure
%          out_db     output object

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

D_B.notyet=0;

switch D_B.proc.type
case 'rplot'
   [out_db,D_B]=d_b_rplot(D_B);
case 'rpows'
   [out_db,D_B]=d_b_rpows(D_B);
case 'tfpows'
   [out_db,D_B]=d_b_tfpows(D_B);
case 'rhist'
   [out_db,D_B]=d_b_rhist(D_B);
case 'evenf'
   D_B=d_b_evfind(D_B);
   D_B.notyet=1;
case 'summary'
   notyet('resume`')
   D_B.notyet=1;
case 'toagd'
   out_db=gen2gd(D_B);
case 'dtfpows'
   [out_db,D_B]=d_b_dtfpows(D_B);
case 'stft'
   [out_db,D_B]=d_b_stft(D_B);
end

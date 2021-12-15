function [tcol colstr colchar]=rotcol(k)
%ROTCOL  color rotation (7 colors)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

k1=mod(k,7);

switch k1
case 1
   tcol=[0 0 1];
   colstr='blue';
   colchar='b';
case 2
   tcol=[1 0 0];
   colstr='red';
   colchar='r';
case 3
   tcol=[0 1 0];
   colstr='green';
   colchar='g';
case 4
   tcol=[0 0 0];
   colstr='black';
   colchar='k';
case 5
   tcol=[1 0 1];
   colstr='magenta';
   colchar='m';
case 6
   tcol=[0 1 1];
   colstr='cyan';
   colchar='c';
case 0
   tcol=[1 1 0];
   colstr='yellow';
   colchar='y';
end

      
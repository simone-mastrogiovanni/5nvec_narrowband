function text=d_b_show(D_B)
%D_B_show   shows the D_B status
%
%           text=D_B_show(D_B)

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ch='none';
switch D_B.data.type
case 1
   styp='snf';
   ch=D_B.data.chname;
case 2
   styp='frames by fmnl';
   ch=D_B.data.chname;
case 3
   styp='frames by framelib';
   ch=D_B.data.chname;
case 4
   styp='R87';
   ch=sprintf('ch %d',D_B.data.chnumber);
case 5
   styp='A.V. format';
   ch=D_B.data.chname;
case 100
   styp='simulation';
end

if D_B.access == 'by file'
   text=sprintf(['                           Data_Browser Status \n'...
      '\n   access type : %s\n'...
      '\n   data type : %s' ...
      '\n   file : %s '...
      '\n   channel : %s \n' ...
      '\n   filtering type : %s \n' ...
      '\n   processing type : %s \n' ...
   ],D_B.access,styp,D_B.data.file,ch,D_B.filter.capt,D_B.proc.type);
else
end

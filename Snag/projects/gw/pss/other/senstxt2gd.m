function [g,fold,file]=senstxt2gd
% SENSTXT2GD  creates a gd from a standard sensitivity file
%
%      [g,fold,file]=senstxt2gd
%

% Version 2.0 - February 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[file,fold]=uigetfile('*.*');
[pathstr, name, ext, versn] = fileparts(file);

a=readascii([fold file],0,2);
a1=a(:,1);
a2=a(:,2);
g=gd(a2);
g=edit_gd(g,'ini',a1(1),'dx',a1(2)-a1(1),'capt',[name 'sensitivity curve']);
fname=name;
eval([name '=g;'])

save(fname,name)
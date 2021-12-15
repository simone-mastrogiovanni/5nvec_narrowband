function a=showol(ol)
%SHOWOL  shows an object list
%
% typical lists gdol, dsol

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=ol.n;

for i = 1:n
   obj=sprintf('%s',ol.type{i});
   num=sprintf('%d',ol.num{i});
   nam=sprintf(' %s',ol.name{i});
   typ=sprintf(' type %d',ol.sty{i});
   dim=sprintf(' dim=%d',ol.dim{i});
   cap=sprintf(' -> %s',ol.capt{i});
   a{i}=strcat(obj,'-',num,': ',nam,typ,dim,cap);
   disp([obj,'-',num,': ',nam,typ,dim,cap]);
end

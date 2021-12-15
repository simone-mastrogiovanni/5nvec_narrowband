
% ol  structure  (gd object list: produces gdol)
%
%  Data members
%
%    name    name
%    num     order number
%    type    type
%    sty     sub-type
%    dim     dimension
%    capt    caption
%
%    obj     objects
%    n       number of objects
%    cont    control variable
%
%  types of lists :
%
%    'gd'
%    'ds'
%    'rs'
%    'ol'
%    'all'

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

clear olscratch;
olscratch.cont=0;
olscratch.obj='rs';
wscratch=whos;
nscratch=length(wscratch);
iiscratch=0;
for iscratch = 1:nscratch
   namscratch=wscratch(iscratch).name;
   typscratch=wscratch(iscratch).class;
   ltypscratch=length(typscratch);
   if ltypscratch == 2
      if typscratch == 'rs'
         iiscratch=iiscratch+1;
         olscratch.name{iiscratch}=namscratch;
         olscratch.num{iiscratch}=iiscratch;
         olscratch.type{iiscratch}='rs';
         olscratch.sty{iiscratch}=0;
         olscratch.dim{iiscratch}=get_rs(eval(namscratch),'n');
         olscratch.capt{iiscratch}=get_rs(eval(namscratch),'capt');
      end
   end
end
olscratch.n=iiscratch;
rsol=olscratch;

showol(olscratch);
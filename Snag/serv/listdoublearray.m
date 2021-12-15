% ol  structure  (double object list: produces doubleol)
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
olscratch.obj='double';
wscratch=whos;
nscratch=length(wscratch);
iiscratch=0;
for iscratch = 1:nscratch
   namscratch=wscratch(iscratch).name;
   typscratch=wscratch(iscratch).class;
   ltypscratch=length(typscratch);
   if ltypscratch == 6
      if typscratch == 'double'
         dimscra=length(eval(namscratch));
         if dimscra > 2
            iiscratch=iiscratch+1;
            olscratch.name{iiscratch}=namscratch;
            olscratch.num{iiscratch}=iiscratch;
            olscratch.type{iiscratch}='double';
            olscratch.sty{iiscratch}=0;
            olscratch.dim{iiscratch}=length(eval(namscratch));
            olscratch.capt{iiscratch}=namscratch;
         end
      end
   end
end
olscratch.n=iiscratch;
doubleol=olscratch;

showol(olscratch);
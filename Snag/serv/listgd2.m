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
%    'gd2'
%    'ds'
%    'rs'
%    'ol'
%    'all'

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

clear olscratch2;
olscratch2.cont=0;
olscratch2.obj='gd2';
wscratch2=whos;
nscratch2=length(wscratch2);
iiscratch2=0;
for iscratch2 = 1:nscratch2
   namscratch2=wscratch2(iscratch2).name;
   typscratch2=wscratch2(iscratch2).class;
   ltypscratch2=length(typscratch2);
   if ltypscratch2 == 3
      if typscratch2 == 'gd2'
         iiscratch2=iiscratch2+1;
         olscratch2.name{iiscratch2}=namscratch2;
         olscratch2.num{iiscratch2}=iiscratch2;
         olscratch2.type{iiscratch2}='gd2';
         olscratch2.sty{iiscratch2}=type_gd2(eval(namscratch2));
         olscratch2.dim{iiscratch2}=n_gd2(eval(namscratch2));
         olscratch2.capt{iiscratch2}=capt_gd2(eval(namscratch2));
      end
   end
end
olscratch2.n=iiscratch2;
gdol2=olscratch2;

%showol(olscratch2);
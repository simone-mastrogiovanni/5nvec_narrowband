% outputs showgdol,  a gd object list
% 

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listgd;
nscra=gdol.n;

clear showgdol;

for i = 1:nscra
   numscra=sprintf('%d',gdol.num{i});
   namscra=sprintf(' %s',gdol.name{i});
   gnamscra=eval(gdol.name{i});
   iniscra=ini_gd(gnamscra);
   inisscra=sprintf(' ini=%d',iniscra);
   dxscra=dx_gd(gnamscra);
   dxsscra=sprintf(' dx=%f',dxscra);
   typscra=sprintf(' > type %d',gdol.sty{i});
   dimscra=sprintf(' dim=%d',gdol.dim{i});
   capscra=sprintf(' -> %s',gdol.capt{i});
   %showgdol{i}=strcat('gd','-',numscra,': ',namscra,typscra,dimscra,dxsscra,capscra)
   showgdol{i}=['gd','-',numscra,': ',namscra,typscra,...
         dimscra,inisscra,dxsscra,capscra];
   disp(['gd','-',numscra,': ',namscra,typscra,dimscra,...
         inisscra,dxsscra,capscra]);
end

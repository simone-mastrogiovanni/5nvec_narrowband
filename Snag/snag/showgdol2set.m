% outputs showgdol2,  a gd2 object list
% 

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listgd2;
nscra=gdol2.n

clear showgdol2;

for i = 1:nscra
   numscra=sprintf('%d',gdol2.num{i});
   namscra=sprintf(' %s',gdol2.name{i});
   gnamscra=eval(gdol2.name{i});
   iniscra=ini_gd2(gnamscra);
   inisscra=sprintf(' ini=%d',iniscra);
   dxscra=dx_gd2(gnamscra);
   dxsscra=sprintf(' dx=%f',dxscra);
   typscra=sprintf(' > type %d',gdol2.sty{i});
   dimscra=sprintf(' dim=%d',gdol2.dim{i});
   capscra=sprintf(' -> %s',gdol2.capt{i});
   %showgdol2{i}=strcat('gd2','-',numscra,': ',namscra,typscra,dimscra,dxsscra,capscra)
   showgdol2{i}=['gd2','-',numscra,': ',namscra,typscra,...
         dimscra,inisscra,dxsscra,capscra];
   disp(['gd2','-',numscra,': ',namscra,typscra,dimscra,...
         inisscra,dxsscra,capscra]);
end

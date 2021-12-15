% outputs showgdoltot,  a gd,gd2 object list
% 

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

showgdolset;
nscragd=gdol.n;
if nscragd < 1
   showgdol={' '};
end

showgdoltot=showgdol;

listgd2;
nscra=gdol2.n

clear showgdol2;
showgdoltot{1+nscragd}=' ';

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
   showgdoltot{i+nscragd+1}=['gd2','-',numscra,': ',namscra,typscra,...
         dimscra,inisscra,dxsscra,capscra];
   disp(['gd2','-',numscra,': ',namscra,typscra,dimscra,...
         inisscra,dxsscra,capscra]);
end

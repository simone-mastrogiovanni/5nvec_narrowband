function g=igd_pol
%IGD_POL  interactive polinomial signal
%
%   interactive call of gd_pol

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg1={'Order of the polinomial' 'Length' 'Sampling time'};
defacg1={'2','1000','1'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

npol=eval(answ{1});

prompt=cell(npol,1);
defarg=cell(npol,1);

for i = 1:npol+1
   prompt{i}=sprintf('Coefficient of order %d',i-1);
   defarg{i}='0';
end

defarg{npol+1}='1';

answ1=inputdlg(prompt,'Coefficients',1,defarg);

for i = 1:npol+1
   coef(i)=eval(answ1{i});
end

eval(['g=gd_pol(''coef'',coef,''len'',' answ{2} ',''dt'',' answ{3} ');']);

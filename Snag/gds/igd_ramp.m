function g=igd_ramp
%IGD_RAMP  interactive ramps signal
%
%   interactive call of gd_ramp

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg1={'Number of ramps (or "pieces")' 'Length' 'Sampling time'};
defacg1={'1','1000','1'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

nramp=eval(answ{1});

prompt=cell(2*nramp+1,1);
defarg=cell(2*nramp+1,1);

prompt{1}='Starting value (value of y(1))';
defarg{1}='0';

for i = 2:2:2*nramp
   prompt{i}=sprintf('Final abscissa of ramp %d  (natural numbers)',i/2);
   defarg{i}=sprintf('%d',i);
end

for i = 3:2:2*nramp+1
   prompt{i}=sprintf('Final ordinate for ramp %d ',(i-1)/2);
   defarg{i}=sprintf('1');
end

answ1=inputdlg(prompt,'Ramps parameters',1,defarg);

absc=zeros(nramp+1,1);
amp=absc;

absc(1)=1;

for i = 1:2:2*nramp+1
   amp((i+1)/2)=eval(answ1{i});
end

for i = 2:2:2*nramp
   absc(i/2+1)=eval(answ1{i});
end

eval(['g=gd_ramp(''absc'',absc,''amp'',amp,''len'',' answ{2} ',''dt'',' answ{3} ');']);

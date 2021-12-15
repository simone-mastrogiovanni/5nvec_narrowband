function g=igd_delt
%IGD_DELT  interactive deltas signal
%
%   interactive call of gd_delt

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg1={'Number of deltas' 'Length' 'Sampling time'};
defacg1={'1','1000','1'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

ndelt=eval(answ{1});

prompt=cell(2*ndelt,1);
defarg=cell(2*ndelt,1);

for i = 1:2:2*ndelt
   prompt{i}=sprintf('Abscissa for delta %d  (natural numbers)',(i+1)/2);
   defarg{i}=sprintf('%d',i);
end

for i = 2:2:2*ndelt
   prompt{i}=sprintf('Amplitude for delta %d ',i/2);
   defarg{i}=sprintf('1');
end

answ1=inputdlg(prompt,'Deltas parameters',1,defarg);

absc=zeros(ndelt,1);
amp=absc;

for i = 1:2:2*ndelt
   absc((i+1)/2)=eval(answ1{i});
end

for i = 2:2:2*ndelt
   amp(i/2)=eval(answ1{i});
end

eval(['g=gd_delt(''absc'',absc,''amp'',amp,''len'',' answ{2} ',''dt'',' answ{3} ');']);

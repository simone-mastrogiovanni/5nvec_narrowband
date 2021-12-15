function g=igd_noise
%IGD_NOISE  interactive random signal
%
%   interactive call of gd_noise

% Version 1.0 - April 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

promptcg1={'Amplitude' 'Length' 'Sampling time' 'Degrees of freedom (for chi-square)'};
defacg1={'1','1000','1' '10'};
answ=inputdlg(promptcg1,'Parameters',1,defacg1);

listprgd={'Gaussian' 'Exponential' 'Chi-square' ...
   'Uniform'};
listprgd1={'gauss' 'exp' 'chisq' 'unif'};
  
  [seldelgd2,sdgok]=listdlg('PromptString','Type of noise ?',...
   'Name','White noise',...
   'ListSize',[150 150],...
   'SelectionMode','single',...
   'ListString',listprgd);

if length(listprgd1{seldelgd2}) == length('chisq')
   if listprgd1{seldelgd2} == 'chisq'
      eval(['g=gd_noise(''amp'',' answ{1} ',''' listprgd1{seldelgd2} ...
            ''',' answ{4} ',''len'',' answ{2} ',''dt'',' answ{3} ');']);
   else
      eval(['g=gd_noise(''amp'',' answ{1} ',''' listprgd1{seldelgd2} ...
            ''',''len'',' answ{2} ',''dt'',' answ{3} ');']);
   end
else
   eval(['g=gd_noise(''amp'',' answ{1} ',''' listprgd1{seldelgd2} ...
         ''',''len'',' answ{2} ',''dt'',' answ{3} ');']);
end




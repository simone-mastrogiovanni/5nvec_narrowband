function var=text2var(text)
%TEXT2VAR  changes non-variable characters to _
%
%      var=text2var(text)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

kk=double(text);

% ii=find(k<48||(k<65&k>57)||(k<95&k>90)||(k<97&k>95)||k>122);
for i = 1:length(text)
   k=kk(i);
   if k<48||(k<65&k>57)||(k<95&k>90)||(k<97&k>95)||k>122
       kk(i)=95;
   end
end
var=char(kk);
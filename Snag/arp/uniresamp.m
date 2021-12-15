function yout=uniresamp(yin,nout)
%UNIRESAMP  uniform resampling
%
%     yout=uniresamp(yin,nout)
%
%     yin    input sequence
%     nout   dimension of output sequence
%
%     yput   output sequence

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (c) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nin=length(yin);

if nin == nout
   yout=yin;
elseif nin < nout
   nk=nout/nin;
   jj=0;
   for i = 1:nin
      ii=round(nk*i);
      yout(jj+1:ii)=yin(i);
      jj=ii;
   end
else
   nk=nin/nout;
   jj=0;
   for i = 1:nout
      ii=round(nk*i);
      yout(i)=mean(yin(jj+1:ii));
      jj=ii;
   end
end

yout=yout(:);
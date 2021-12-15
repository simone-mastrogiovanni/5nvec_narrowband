function mp_stat(mp)
%MP_STAT   statistics for multiple plot
%
% mp structure (multiplot):
%
%     mp.nch
%     mp.ch(i).name
%             .n
%             .x
%             .y
%             .unitx
%             .unity

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

for i = 1:mp.nch
   mini=min(mp.ch(i).y);
   maxi=max(mp.ch(i).y);
   mea=mean(mp.ch(i).y);
   sd=sqrt(var(mp.ch(i).y));
   fprintf(' %d  %e  %e    %e  %e\n',i,mea,sd,mini,maxi);
end

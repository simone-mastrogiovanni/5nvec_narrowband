function display_rs(r)
%DS/DISPLAY_RS display an rs

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

rn=sprintf('%d',r.n);
dt=sprintf('%d',r.dt);

disp([' rs ',rn,' resonances - dt=',dt,' -> ',r.capt])
disp(' ')

for i = 1:r.n
   ii=sprintf('%u',i);
   fr=sprintf('%d',r.fr(i));
   tau=sprintf(', %d',r.tau(i));
   ww=sprintf('; w = %d, %d',real(r.w(i)),imag(r.w(i)));
   disp(['      resonance ',ii,' -> fr,tau= ',fr,tau,ww])
end
function display(a)
%DISPLAY   displays a am object
%

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

na=sprintf('%d',a.na);
nb=sprintf('%d',a.nb);

bil=' ';
if a.bilat > 0
   bil=' bilateral ';
end

disp([' ARMA filter ' inputname(1) ' AR ' na ' MA ' nb bil '> ' a.capt]);
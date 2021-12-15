function Adel=delay_5vect(A,fr,del,cont)
% DELAY_5VEC  delays a 5-vect
%
%    Adel=delay_5vect(A,del)
%
%   A    input 5-vect
%   fr   frequency
%   del  delay (s)
%   cont =0 normale, =1 A3 to 0, =2 to pi

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('cont','var')
    cont=0;
end

ST=86164.09053083288;

switch cont
    case 0
        fi0=2*pi*fr*del;
    case 1
        fi0=-angle(A(3));
    case 2
        fi0=pi-angle(A(3));
end

fi1=2*pi*del/ST;%fi1=0;

FI=fi0+[-2*fi1 -fi1 0 fi1 2*fi1];

Adel=A(:).'.*exp(1j*FI);
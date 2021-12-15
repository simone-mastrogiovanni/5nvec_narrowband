function a=y_ds(d)
%DS/Y_DS  extracts the last written y
%
%       a=y_ds(d)

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if d.type == 2
    if floor(d.lcw/2)*2 == d.lcw
       a=d.y2(1:d.len);
    else
       a=d.y1(1:d.len);
    end
else
    a=d.y1(1:d.len);
end

a=a(:);

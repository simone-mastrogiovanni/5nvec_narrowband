function b=transpose(a)
% transposition of a type-1 gd2

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics -  Sapienza Rome University

if a.type == 2
    disp(' *** operation not possible: type 2 gd2')
    return
end

b=a;

b.y=a.y.';
b.ini=a.ini2;
b.ini2=a.ini;
b.dx=a.dx2;
b.dx2=a.dx;
b.m=a.n/a.m;
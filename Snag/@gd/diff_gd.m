function a=diff_gd(b,lim)
%GD/DIFF_GD  derivative with possible limit

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

a=b;

a.y(2:a.n)=diff(b.y);
a.y(1)=a.y(2);

if exist('lim')
    for i = 1:a.n
        if a.y(i) > lim
            a.y(i)=a.y(i)-2*lim;
        end
        if a.y(i) < -lim
            a.y(i)=a.y(i)+2*lim;
        end
    end
end
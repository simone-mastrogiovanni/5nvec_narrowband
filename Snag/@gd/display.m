function display(g)
%GD/DISPLAY display a gd

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

st=sprintf('%d',g.n);
in=sprintf('%d',g.ini);
dx=sprintf('%d',g.dx);
ty=sprintf('%d',g.type);
con=' ';
if isa(g.cont,'double')
    if g.cont ~= 0
        con=sprintf(' cont= %f',g.cont);
    end
end
    
disp([' gd ',inputname(1),' -> n=',st,' ini=',in,' dx=',dx,...
   ' type=',ty,con,' -> ',g.capt])

if isstruct(g.cont)
    ic=0;
    if isfield(g.cont,'ant')
        ant=g.cont.ant;
    else
        ant='no-ant';
    end
    str=sprintf(' BSD %s t/f: ',ant);
    if isfield(g.cont,'t0')
        ini=g.cont.t0;
        fin=ini+g.n*g.dx/86400;
        vin=mjd2v(ini);
        vfi=mjd2v(fin);
%         str1=sprintf('t0 = %f ',g.cont.t0);
        str1=sprintf('%d-%d-%d %d:%d:%d <> %d-%d-%d %d:%d:%d | ',vin(1:5),round(vin(6)),vfi(1:5),round(vfi(6)));
        str=[str str1];
        ic=ic+1;
    end
    if isfield(g.cont,'inifr')
        str1=sprintf(' %.3f ',g.cont.inifr);
        str=[str str1];
        ic=ic+1;
    end
    if isfield(g.cont,'bandw')
        str1=sprintf('<> %.3f Hz',g.cont.inifr+g.cont.bandw);
        str=[str str1];
        ic=ic+1;
    end
    if ic == 3
        disp(str)
    end
end
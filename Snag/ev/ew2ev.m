function ev=ew2ev(ew)
%EW2EV   from structure of arrays to array of structure

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=ew.nev;

for i = 1:n
    ev(i).t=ew.t(i);
    ev(i).tm=ew.tm(i);
    ev(i).ch=ew.ch(i);
    ev(i).a=ew.a(i);
    ev(i).cr=ew.cr(i);
    ev(i).a2=ew.a2(i);
    ev(i).l=ew.l(i);
    ev(i).fl=ew.fl(i);
    ev(i).ci=ew.ci(i);
end

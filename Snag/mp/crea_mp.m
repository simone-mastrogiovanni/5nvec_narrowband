function mp=crea_mp(n)
%CREA_MP  creates a "simulated" multiplot structure of dimenson n

% Version 2.0 - May 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

mp.nch=n;

for i = n:-1:1
    mp.ch(i).name=sprintf('ch %3d',i);
    mp.ch(i).x=1:200;
    mp.ch(i).y=zeros(1,200);
    mp.ch(i).unitx='s';
    mp.ch(i).unity='V';
    mp.ch(i).n=200;
    mp.ch(i).ch=i;
end

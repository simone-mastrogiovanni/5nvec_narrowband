function source=crea_pssource0(n,hmax,frmax)
%CREA_PSSOURCE0  creates an array of n sources uniformly distributed on the
%                sky, with simple parameters

% Version 2.0 - June 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

set_random
alf=rand(1,n)*360;
c=cos(-pi/2:0.01:pi/2);
F=cumsum(c);
N=length(F);
F=F/F(N);
delt=gen_random(F,-pi/2,0.01,n);
delt=delt*180/pi;
fr=rand(1,n)*frmax;
h=rand(1,n)*hmax;

for i=1:n
    source(i).a=alf(i);
    source(i).d=delt(i);
    source(i).eps=1;
    source(i).psi=0;
    source(i).t00=v2mjd([2000,1,1,0,0,0]);
    source(i).f0=fr(i);
    source(i).df0=0;
    source(i).ddf0=0;
    source(i).h=h(i);
    source(i).snr=1;
    source(i).coord=0;
    source(i).chphase=0;
end
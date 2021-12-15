function [g2 detpr]=nea_coin(fap,sig1,sig2,red)
% NEA_COIN  not equal antennas coincidences
%
% The two antennas have the same false alarm prob, but different signal
% gain. The detection parameter is computed, for different values of the
% two thresholds.
%
%       g2=nea_coin(fap,sig1,sig2,red)
%
%    fap         false alarm probability (gd)
%    sig1,sig2   the signal as seen by the two antennas
%    red         reduction coefficient for the threshold (respect to the resolution of fap) 
%
%    g2          gd2 containing the detection parameter

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dx=dx_gd(fap);
ini=ini_gd(fap);
n=n_gd(fap);
fap=y_gd(fap);
d0=round(-ini/dx);
d1=round(sig1/dx);
d2=round(sig2/dx);
ns=round((n-d0)/red)-1;
g2=zeros(ns,ns);
detpr=g2;

for i = 1:ns
    fa1=fap((i-1)*red+d0);
    i1=(i-1)*red+d0-d1;
    for j = 1:ns
        fa2=fap((j-1)*red+d0);
        fa=fa1*fa2;
        j1=(j-1)*red+d0-d2;%disp([ns,i,j,i1,j1])
        p=fap(i1)*fap(j1);
        detpr(i,j)=p;
        sqr=sqrt(fa*(1-fa));
        if sqr > 0
            g2(i,j)=(p-fa)/sqr;
        else
            g2(i,j)=0;
        end
    end
end

g2=gd2(g2);
g2=edit_gd2(g2,'dx',dx*red,'dx2',dx*red,'capt','detection parameter');
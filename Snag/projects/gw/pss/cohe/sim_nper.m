function [mf1 mfn c1 cn]=sim_nper(sour,ant,np,A)
% SIM_NPER  simulation of n periods analysis
%
%    sour,ant   source and antenna structures
%    np         number of periods
%    A          amplitude

% Version 2.0 - October 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

N=100000;
[L0 L45 CL CR V Hp Hc]=sour_ant_2_5vec(sour,ant);
L0n=L0/np;
L45n=L45/np;
Vn=V/np;

for i = 2:np
    L0n=[L0n L0/np];
    L45n=[L45n L45/np];
    Vn=[Vn V/np];
end

N1=(randn(N,5)+1j*randn(N,5))/sqrt(2);
Nn=(randn(N,np*5)+1j*randn(N,np*5))/sqrt(2*np);
mf1=zeros(1,N);
mfn=mf1;
c1=mf1;
cn=mf1;

for i = 1:N
    X=A*V+N1(i,:);
    Xn=A*Vn+Nn(i,:);

    [mf1(i) c1(i)]=mfcohe_5vec(X,V);
    [mfn(i) cn(i)]=mfcohe_5vec(Xn,Vn);
end
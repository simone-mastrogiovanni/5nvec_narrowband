function [np sp t f]=pmf_prepare(gA,band)
% creates tables to produce pmfs 
%
%   pmf=pmf_from_peaks(A,bandw,kres)
%
%   gA      input peaks (in gd2)
%   band    band [minfr maxfr dfr]

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

minfr=band(1);
maxfr=band(2);
dfr1=band(3);

A=y_gd2(gA);
[nit n2]=size(A);
fr0=ini2_gd2(gA);
dfr=dx2_gd2(gA);
fr=x2_gd2(gA);
kfr=dfr1/dfr;
ii=round(floor(kfr):kfr:n2);
fprintf('Input dfr = %f ;  true dfr = %f \n',dfr1,dfr)
nfr=round((maxfr-minfr)/dfr1);
sp=zeros(nit,nfr-1);
t=x_gd2(gA);
N=abs(sign(A));

C=cumsum(N')';
C=C(:,ii);
np=diff(C')';

for i = 1:nit
    C=N(i,:).*fr';
    C=cumsum(C);
    C=C(ii);
    sp(i,:)=diff(C);
end

[n1 n2]=size(np);
f=minfr+dfr1*(1:n2)-dfr1/2;
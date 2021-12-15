function [cand1A,cand2A]=psc_maxcoin(cand1,cand2,dfr)
%PSC_MAXCOIN  max CR coincidence candidates
%             the cand1 CR is used, frequency is the principal parameter 
%
%       [cand1A,cand2A]=psc_maxcoin(cand1,cand2,dfr)
%
%   cand1,cand2   candidate matrices
%   dfr           frequency half window

% Version 2.0 - September 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('dfr','var')
    dfr=0.001;
end

fr=cand1(1,:);
[B,IX]=sort(fr);
fr=fr(IX);
cand1=cand1(:,IX);
cand2=cand2(:,IX);
cand1A=zeros(7,0);
cand2A=zeros(7,0); 

imax=find(diff(fr)>2*dfr)-1;

imin=1;

for i = 1: length(imax)
    [cr,icr]=max(cand1(5,imin:imax(i)));
    icr=icr+imin-1;
    cand1A=[cand1A cand1(:,icr)];
    cand2A=[cand2A cand2(:,icr)];
    imin=imax(i)+1;
end

imax=length(fr);
[cr,icr]=max(cand1(5,imin:imax));
icr=icr+imin-1;
cand1A=[cand1A cand1(:,icr)];
cand2A=[cand2A cand2(:,icr)];
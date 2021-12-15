function [sour sp stot peakfr peaka peakfrl0 peakal0]=multi_estimate_3sig(gin,gl0,gl45,DT,thr,fr0)
% multi_estimate_3sig  estimates source parameters from subintervals
%                      (3sig method)
%
%    sour=multi_estimate_3sig(gin,gl0,gl45,DT,fr0)
%
%   gin    data gd
%   gl0    simulated l0 signal gd
%   gl45   simulated l45 signal gd
%   DT     sub-periods length (days)
%   thr    threshold
%   fr0    frequency (if absent the default)
%
%   sour   source parameters

% Version 2.0 - June 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

dt=dx_gd(gin);
cont=cont_gd(gin);
fr=cont.appf0;
if ~exist('fr0','var')
    fr0=fr-floor(fr*dt)/dt;
end

gin=rough_clean(gin,-thr,thr,60);
obs=check_nonzero(gin,1);

[A sp stot peakfr peaka]=multi_5vect(gin,DT,fr0);
[A0 sp0 stot0 peakfrl0 peakal0]=multi_5vect(gl0.*obs',DT,fr0);%disp('!!!!'),size(A0)
A45=multi_5vect(gl45.*obs',DT,fr0);

[i1 i2]=size(A);

for i = 1:i1
    [sour1 stat1]=estimate_psour(A(i,:),A0(i,:),A45(i,:));
    sour(i).h0=sour1.h0;
    sour(i).eta=sour1.eta;
    sour(i).psi=sour1.psi;
    sour(i).cohe=stat1.cohe(3);
end

fprintf(' per.    h0        eta        psi       cohe \n')

for i = 1:i1-1
    fprintf('  %d : %f  %f  %f  %f \n',i,sour(i).h0,sour(i).eta,sour(i).psi,sour(i).cohe);
end

fprintf('tot : %f  %f  %f  %f \n',sour(i1).h0,sour(i1).eta,sour(i1).psi,sour(i1).cohe);
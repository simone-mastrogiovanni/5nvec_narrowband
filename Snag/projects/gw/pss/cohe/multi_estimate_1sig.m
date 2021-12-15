function [sour sp stot]=multi_estimate_1sig(gin,ant,DT,fr0)
% multi_estimate_1sig  estimates source parameters from subintervals
%                      (1sig method)
%
%    sour=multi_estimate_1sig(gin,gl0,gl45,DT,fr0)
%
%   gin    data gd
%   ant    antenna structure
%   DT     sub-periods length (days)
%   fr0    frequency (if absent the default)
%
%   sour   source parameters

% Version 2.0 - July 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

dt=dx_gd(gin);
cont=cont_gd(gin);
fr=cont.appf0;
if ~exist('fr0','var')
    fr0=fr-floor(fr*dt)/dt;
end

sour.a=cont.alpha;
sour.d=cont.delta;
sour.eta=0;
sour.psi=0;
[L0 L45]=sour_ant_2_5vec(sour,ant);

[A sp stot]=multi_5vect(gin,DT,fr0);
% A0=multi_5vect(gl0,DT,fr0);
% A45=multi_5vect(gl45,DT,fr0);

[i1 i2]=size(A);

for i = 1:i1
    [sour1 stat1]=estimate_psour(A(i,:),L0,L45);
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
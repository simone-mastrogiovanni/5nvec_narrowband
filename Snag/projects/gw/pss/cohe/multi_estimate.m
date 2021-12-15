function [sourest sp stot gl0 gl45 obs spar]=multi_estimate(gin,ant,DT,thr,fr0)
% multi_estimate_3sig  estimates source parameters from subintervals
%                      (3sig method)
%
%    sour=multi_estimate_3sig(gin,gl0,gl45,DT,fr0)
%
%   gin      data gd
%   ant      antenna structure
%   DT       sub-periods length (days)
%   thr      threshold
%   fr0      frequency (if absent the default)
%
%   sourest  source parameters

% Version 2.0 - June 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

SD=86164.09053083288;

dt=dx_gd(gin);
N=n_gd(gin);
cont=cont_gd(gin);
fr=cont.appf0;
if ~exist('fr0','var')
    fr0=fr-floor(fr*dt)/dt;
end
t0=cont.t0;
sour=cont.sour;

gin=rough_clean(gin,-thr,thr,60);
obs=check_nonzero(gin,1);

[A sp stot spar]=multi_5vect(gin,DT,fr0,ant);

ph0=mod(fr*dt*(0:N-1),1)*2*pi;

nsid=10000;
[A0 A45 Al Ar sid1 sid2]=check_ps_lf(sour,ant,nsid);
eta=sour.eta;
psi=sour.psi*pi/180;
fi=2*psi;
Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));

stsub=gmst(t0)+dt*(0:N-1)*(86400/SD)/3600;
i1sub=mod(round(stsub*(nsid-1)/24),nsid-1)+1;

gl0=sid1(i1sub).*exp(1j*ph0);
gl0=edit_gd(gin,'y',gl0);
gl45=sid2(i1sub).*exp(1j*ph0);
gl45=edit_gd(gin,'y',gl45);

A0=multi_5vect(gl0.*obs,DT,fr0,ant);
A45=multi_5vect(gl45.*obs,DT,fr0,ant);

[i1 i2]=size(A);

for i = 1:i1
    [sour1 stat1]=estimate_psour(A(i,:),A0(i,:),A45(i,:));
    sourest(i).h0=sour1.h0;
    sourest(i).eta=sour1.eta;
    sourest(i).psi=sour1.psi;
    sourest(i).cohe=stat1.cohe(3);
end

fprintf(' per.    h0          eta         psi        cohe \n')

for i = 1:i1-1
    fprintf('  %d : %f E  %f  %f  %f \n',i,sourest(i).h0,sourest(i).eta,sourest(i).psi,sourest(i).cohe);
end

fprintf('tot : %f E  %f  %f  %f \n\n',sourest(i1).h0,sourest(i1).eta,sourest(i1).psi,sourest(i1).cohe);

fprintf('true: %e  %f  %f  \n\n',sour.h,sour.eta,sour.psi);

fprintf('     h0 ratio, eta and psi errors, 5 frequencies errors in natural units \n')
fprintf(' per.   h0    eta     psi      \n')

for i = 1:i1-1
    errpsi=sourest(i).psi-sour.psi;
    if abs(errpsi) > 45
        errpsi=errpsi-sign(errpsi)*90;
    end
    fprintf('  %d : %5.3f  %5.3f  %6.2f ;  %5.2e  %5.2e  %5.2e  %5.2e  %5.2e \n',...
        i,sourest(i).h0/(sour.h*1e20),sourest(i).eta-sour.eta,errpsi,spar.fr(:,i)*DT*86400);
end

errpsi=sourest(i1).psi-sour.psi;
if abs(errpsi) > 45
    errpsi=errpsi-sign(errpsi)*90;
end
    
fprintf('tot : %5.3f  %5.3f  %6.2f ;  %5.2e  %5.2e  %5.2e  %5.2e  %5.2e \n',...
    sourest(i1).h0/(sour.h*1e20),sourest(i1).eta-sour.eta,errpsi,spar.fr(:,i1)*dt*N);

fprintf('   "out-band", frequencies errors and amplitudes \n')

for i = 1:i1-1
    fprintf('  %d : %5.2e | %5.2e  %5.2e |   %5.2e  %5.2e |   %5.2e  %5.2e |   %5.2e  %5.2e |   %5.2e  %5.2e  \n',...
    i,spar.fb(i),spar.fr(1,i),spar.apeak(1,i),spar.fr(2,i),spar.apeak(2,i),...
    spar.fr(3,i),spar.apeak(3,i),spar.fr(4,i),spar.apeak(4,i),spar.fr(5,i),spar.apeak(5,i));
end
    
fprintf('tot : %5.2e | %5.2e  %5.2e |   %5.2e  %5.2e |   %5.2e  %5.2e |   %5.2e  %5.2e |   %5.2e  %5.2e \n',...
    spar.fb(i1),spar.fr(1,i1),spar.apeak(1,i1),spar.fr(2,i1),spar.apeak(2,i1),...
    spar.fr(3,i1),spar.apeak(3,i1),spar.fr(4,i1),spar.apeak(4,i1),spar.fr(5,i1),spar.apeak(5,i1));
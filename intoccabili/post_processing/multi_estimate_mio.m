function [sourest sp stot gl0 gl45 obs spar A A0 A45]=multi_estimate_mio(gin,ant,DT,thr,Dt_v,fr0)
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
% Department of Physics - Universit? "Sapienza" - Rome

SD=86164.09053083288;
FS=1/86164.09053083288;

dt=dx_gd(gin);
N=n_gd(gin);
cont=cont_gd(gin);
fr=cont.appf0;
if ~exist('Dt_v','var')
    Dt_v=100
end
if ~exist('fr0','var')
    fr0=fr-floor(fr*dt)/dt;
end
t0=cont.t0;
sour=cont.sour;

    
gin=rough_clean(gin,-thr,thr,60);
obs=check_nonzero(gin,1);

[A sp stot spar]=multi_5vect(gin,DT,fr0,ant);

%A=A
[i1 i2]=size(A);
%Atot=A(i1,:)

if Dt_v ~= 100
    for i=1:i1
        for k=1:5
            ph(k)=mod((fr0+(-3+k)*FS)*Dt_v,1)*2*pi;
            A(i,k)=A(i,k)*exp(1j*ph(k));     
        end
    end
end
Atot=A(i1,:)
ph0=mod(fr0*dt*(0:N-1),1)*2*pi;

nsid=10000;
[A0 A45 Al Ar sid1 sid2]=check_ps_lf(sour,ant,nsid);
eta=sour.eta;
psi=sour.psi*pi/180;
Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));

stsub=gmst(t0)+dt*(0:N-1)*(86400/SD)/3600;
i1sub=mod(round(stsub*(nsid-1)/24),nsid-1)+1;

gl0=sid1(i1sub).*exp(1j*ph0);
gl0=edit_gd(gin,'y',gl0.*obs');
%gl0=edit_gd(gin,'y',gl0);
%gl0=gl0.*obs;
gl45=sid2(i1sub).*exp(1j*ph0);
gl45=edit_gd(gin,'y',gl45.*obs');
%gl45=edit_gd(gin,'y',gl45);
%gl45=gl45.*obs;
%gl0=gl0
%gl45=gl45

A0=multi_5vect(gl0,DT,fr0,ant);
A45=multi_5vect(gl45,DT,fr0,ant);
%A0=A0;
%A45=A45;
% if Dt_v ~= 100
%     for i=1:i1
%         for k=1:5
%             %A0(i,k)=A0(i,k)*exp(1j*ph(k));     
%             %A45(i,k)=A45(i,k)*exp(1j*ph(k));
%         end
%     end
% end
A0tot=A0(i1,:)
A45tot=A45(i1,:)

for i = 1:i1
    [sour1 stat1]=estimate_psour_mio(A(i,:),A0(i,:),A45(i,:));
    sourest(i).h0=sour1.h0;
    sourest(i).eta=sour1.eta;
    sourest(i).psi=sour1.psi;
    sourest(i).cohe=stat1.cohe(3);
    sourest(i).absph1=angle(sour1.absphp);
    sourest(i).absph2=angle(sour1.absphp);
    sourest(i).absph3=angle(sour1.absphp);
end



fprintf(' per.    h0          eta         psi        cohe \n')

for i = 1:i1-1
    fprintf('  %d : %e E  %f  %f  %f %f %f %f \n',i,sourest(i).h0,sourest(i).eta,sourest(i).psi,sourest(i).cohe,...
        sourest(i).absph1,sourest(i).absph2,sourest(i).absph3);
end

fprintf('tot : %e E  %f  %f  %f  %f %f %f \n\n',sourest(i1).h0,sourest(i1).eta,sourest(i1).psi,sourest(i1).cohe,...
    sourest(i1).absph1,sourest(i1).absph2,sourest(i1).absph3);

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

%%%%%%%%%%%Folding and equalization%%%%%%%%%%%%%%%%%%%%%%%%

[geq weq d5eq d5 w5 A0 A45 A0_deq A45_deq]=tsid_equaliz(gin,1,ant);
[gl0_eq weq0 d5eq d5 w5 A0 A45 A0_deq A45_deq]=tsid_equaliz(gl0,1,ant);
[gl45_eq weq45 d5eq d5 w5 A0 A45 A0_deq A45_deq]=tsid_equaliz(gl45,1,ant);
geq=geq./weq;
gl0_eq=gl0_eq./weq0;
gl45_eq=gl45_eq./weq45;
[Xeq fr1 fact0corr1]=compute_5comp_num(geq,0,ant);   
[A0_eq fr fact0corr1]=compute_5comp_num(gl0_eq,0,ant);
[A45_eq fr fact0corr1]=compute_5comp_num(gl45_eq,0,ant);
[h0_eq eta_eq psi_eq phi0_eq cohe_eq]=estipar(Xeq,A0_eq,A45_eq);
fprintf('Equalization --- h0=%e  eta=%f  psi=%f  phi0=%f cohe=%f\n',h0_eq,eta_eq,psi_eq,phi0_eq,cohe_eq);

X_eq=multi_5vect(geq,DT,0,ant);
A0_eq=multi_5vect(gl0_eq,DT,0,ant);
A45_eq=multi_5vect(gl45_eq,DT,0,ant);
for i = 1:i1
    [sour1 stat1]=estimate_psour_mio(X_eq(i,:),A0_eq(i,:),A45_eq(i,:));
    sourest(i).h0=sour1.h0;
    sourest(i).eta=sour1.eta;
    sourest(i).psi=sour1.psi;
    sourest(i).cohe=stat1.cohe(3);
end
for i = 1:i1-1
    fprintf('  %d : %f E  %f  %f  %f\n',i,sourest(i).h0,sourest(i).eta,sourest(i).psi,sourest(i).cohe);
end


function [A fr fact0corr]=compute_5comp_num(gin,fr0,ant,mask)

cont=cont_gd(gin);
t0=cont.t0;
lst=(gmst(t0)+ant.long/15)*3600;
y=y_gd(gin);
t=x_gd(gin);
%t=t-t(1)+lst;
%t=t-t(1);
t=t+lst;
dt=dx_gd(gin);
n=n_gd(gin);

if exist('mask','var')
    y=y.*mask(:);
end

FS=1/86164.09053083288;

fr=fr0+(-2:2)*FS;

i=find(y);
T=dt*length(i);
Ttot=dt*length(y);
fact0corr=Ttot/T;

%disp('     compute_5comp')
%disp(' i   fr   real  imag  abs angle')

for i = 1:5
    A(i)=sum(y.*exp(-1j*2*pi*fr(i)*t))*dt;
    %disp(sprintf(' %d  %f  %e  %e  %e  %7.2f ',i-3,fr(i),real(A(i)),imag(A(i)),abs(A(i)),angle(A(i))*180/pi))
end


function [h0 eta psi phi0 cohe]=estipar(X,A0,A45)

mf0=conj(A0)./norm(A0).^2;
mf45=conj(A45)./norm(A45).^2;
%mf0=conj(A0)
%mf45=conj(A45);
hp=sum(X.*mf0)
hc=sum(X.*mf45);
% if length(X) == 10
% x1=sum(X(1:5).*mf0(1:5))
% x2=sum(X(6:10).*mf0(6:10))
% y1=mf0(1:5)
% y2=mf0(6:10)
% end
h0=sqrt(norm(hp)^2+norm(hc)^2);


a=hp/h0;
b=hc/h0;

A=real(a*conj(b));
B=imag(a*conj(b));
C=norm(a)^2-norm(b)^2;

eta=(-1+sqrt(1-4*B^2))/(2*B);
cos4psi=C/sqrt((2*A)^2+C^2);
sin4psi=2*A/sqrt((2*A)^2+C^2);
psi=(atan2(sin4psi,cos4psi)/4)*180/pi;
phi0=angle(hp/(h0*(cos(2*psi*pi/180)-1j*eta*sin(2*psi*pi/180))));


sig=hp*A0+hc*A45;
[mf cohe]=mfcohe_5vec(X,sig);

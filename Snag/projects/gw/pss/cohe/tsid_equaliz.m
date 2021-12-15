function [geq weq d5eq d5 w5 A0 A45 A0_deq A45_deq]=tsid_equaliz(gin,wien,ant)
% TSID_EQUALIZE  equalizes for the sidereal period)
%
%   [geq weq d5eq d5 w5 A0 A45 A0_deq A45_deq]=tsid_equaliz(gin,wien,ant)
%
%   gin       input data
%   wien      wiener vector (or 1)
%   ant       ...
%

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if length(wien) == 1
    wien=check_nonzero(gin);
end
ST=86164.09053083288;
cont=cont_gd(gin);
t0=cont.t0;
% t0sid=(gmst(t0)+ant.long/15)*3600;
sour.a=cont.alpha;
sour.d=cont.delta;
fr0=cont.appf0;
dt=dx_gd(gin);
fr1=fr0-floor(fr0*dt)/dt;
N=floor(ST/dt);
long=ant.long;

[A0 A45 Al Ar l0 l45 cr cl]=check_ps_lf(sour,ant,N);

weq=zeros(1,N)';
yeq=weq;
y=y_gd(gin);
n=n_gd(gin);
x=x_gd(gin);
x=x-x(1);
y=y.*exp(-1j*2*pi*fr1.*x);
tot=0;

for i = 1:N:n-N
    tot=tot+1;
    
    it1=round((gmst(t0+(i-1)*dt/86400))*3600/dt);
%     it1=round((gmst(t0+(i-1)*dt/86400)-long/15)*3600/dt);
%     it1=round((gmst(t0+(i-1)*dt/86400)-long/15+sour.a/15)*3600/dt);
%     it1=round((gmst(t0+(i-1)*dt/86400)+long/15-sour.a/15)*3600/dt);
    if it1 < 1
        it1=it1+N;
    end
    if it1 > N
        it1=it1-N;
    end
    n1=N-it1;
    weq(it1:N)=weq(it1:N)+wien(i:i+n1);
    weq(1:it1-1)=weq(1:it1-1)+wien(i+n1+1:i+N-1);
    yeq(it1:N)=yeq(it1:N)+y(i:i+n1);
    yeq(1:it1-1)=yeq(1:it1-1)+y(i+n1+1:i+N-1);
end

weq=weq/tot;
geq=edit_gd(gin,'y',yeq,'capt',['ST on ' capt_gd(gin)]);

x=(0:N-1)'*dt*2*pi/ST;

for i = 1:5
    w5(i)=sum(weq.*exp(1j*(i-3)*x))*dt;
    d5(i)=sum((y_gd(geq)).*exp(-1j*(i-3)*x))*dt;
    d5eq(i)=sum((y_gd(geq)./weq).*exp(-1j*(i-3)*x))*dt;
    A0_deq(i)=sum((l0.'.*weq).*exp(-1j*(i-3)*x))*dt;
    A45_deq(i)=sum((l45.'.*weq).*exp(-1j*(i-3)*x))*dt;
end

w5=w5/N;
d5=d5/N;
d5eq=d5eq/N;
A0_deq=A0_deq/N;
A45_deq=A45_deq/N;

mr=max(abs(real(gin)));
mi=max(abs(imag(gin)));
if mr >= mi
    str='real part ';
    figure,plot(real(y_gd(geq))),figure,plot(real(y_gd(geq))./weq,'r'),grid on,title([str '; red: equalized'])
else
    str='imaginary part ';
    figure,plot(imag(y_gd(geq))),figure,plot(imag(y_gd(geq))./weq,'r'),grid on,title([str '; red: equalized'])
end
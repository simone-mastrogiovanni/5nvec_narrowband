function [v,tculm,rv]=bsd_5vec(bsd,frs,rasc,tref)
% computes the 5-vec for a bsd
%
%     v=bsd_5vec(bsd,frs,rasc)
%
%   bsd    input bsd
%   frs    frequencies
%   rasc   right ascension (deg) (if present: normally the oper structure is used)
%   tref   reference time (def t0)

% Snag Version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

FS=1/86164.09053083288;
Dfr=(-2:2)*FS;

y=y_gd(bsd);
N=n_gd(bsd);
dt=dx_gd(bsd);
cont=ccont_gd(bsd);
t0=cont.t0;
inifr=cont.inifr;

if ~exist('rasc','var')
    norasc=1;
    if isfield(cont,'oper')
        oper=cont.oper;
        if isfield(oper,'sour')
            sour=oper.sour;
            rasc=sour.a;
            norasc=0;
        end
    end
    if norasc
        error('no value for right ascension')
    end
end

eval(['ant=' cont.ant ';'])
long=ant.long;

if exist('tref','var')
    t0=tref;
end
[mjd,t1,t2]=t_culm(long,rasc,t0);
tculm=mjd;
Dt0=diff_mjd(mjd,t0);

% st=gmst(cont.t0)*3600;
% t=(0:N-1)'*dt+st;

n=length(frs);
v=zeros(5,n);
t=(0:N-1)'*dt+Dt0;
T0=N*dt;
Na=sum(sign(abs(y)));
T0a=Na*dt;

for i = 1:n
    fr=frs(i)-inifr+Dfr;
    for j = 1:5
        v(j,i)=sum(y.*exp(-1j*2*pi*fr(j).*t))/Na;
    end
end

rv=v;
% y=y(randperm(length(y)));
% for i = 1:n
%     fr=frs(i)-inifr+Dfr;
%     for j = 1:5
%         rv(j,i)=sum(y.*exp(-1j*2*pi*fr(j).*t))/Na;
%     end
% end
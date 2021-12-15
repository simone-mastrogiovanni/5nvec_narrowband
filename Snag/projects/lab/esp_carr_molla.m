function [g,s,ep,ec,w,mot,g1,ep1,ec1,w1]=esp_carr_molla(fr,data)
%ESP_MOLLA  simulazione dati molla
%
%  fr   frequenza o campioni motitazione
%
%  data.T=100;     % tempo di osservazione
%  data.dt=0.01;   % tempo integrazione
%  data.st=0.05;        % sampling time
%  data.beta=0;    % coefficienti attrito viscoso
%  data.kmolla=2;  % k molla
%  data.massa=1;   % massa carrello
%  data.muv=0.3;   % coefficiente attrito volvente
%  data.A=1;       % ampiezza eccitazione
%  data.x0=10;     % posizione per risposta impulsiva (fr=0)
%  data.v0=0;      % velocità iniziale
%  data.tsmooth=10;% tempo di smussamento
%
%  data.modo  0 con grafico, 1 senza
%
%  g    posizione
%  s    posizione campionata
%  ep   energia potenziale
%  w    potenza
%  ec   energia cinetica
%  mot  eccitazione motore
%  g1   posizione raffinata (per verifica)

ifr=0;
fr0=fr;

if ~exist('data','var')
     data.T=100;
     data.dt=0.01;
     data.beta=0;
     data.kmolla=1.5;
     data.massa=1;
     data.muv=0.2;
     data.x0=10;
     data.v0=0;
     data.tsmooth=50
end

if ~isfield(data,'T')
     data.T=100;
end
if ~isfield(data,'dt')
     data.dt=0.01;
end
if ~isfield(data,'st')
     data.st=0.05;
end
if ~isfield(data,'massa')
     data.massa=1;
end
if ~isfield(data,'beta')
     data.beta=0;
end
if ~isfield(data,'kmolla')
     data.kmolla=1.5;
end
if ~isfield(data,'muv')
     data.muv=0.2;
end
if ~isfield(data,'A')
     data.A=1;
end
if ~isfield(data,'x0')
     data.x0=10;
end
if ~isfield(data,'v0')
     data.v0=0;
end
if ~isfield(data,'tsmooth')
     data.tsmooth=50;
end
if ~isfield(data,'modo')
     data.modo=0;
end

ss=data.st/data.dt;
x0=data.x0;
N=ceil(data.T/data.dt);

if length(fr) == 1
    ifr=1;
    if fr ~= 0
        x0=0;
        fr=sin(fr*2*pi*(0:N-1)*data.dt);
    else
        fr=(0:N-1)*0;
    end
end

x=zeros(N,1);
ec=x;
ep=x;
w=x;
dt=data.dt;
x(1)=x0;
vx=data.v0;
kk=data.kmolla/data.massa;
bet=data.beta/data.massa;
cost=data.muv/data.massa;
svx=sign(vx);
nsm=round(data.tsmooth/dt);
fr(1:nsm)=fr(1:nsm).*(1-cos(pi*(1:nsm)/nsm))/2;
fr=fr*data.A;

for i = 2:N
    ax=-kk*(x(i-1)-fr(i-1))-svx*cost-bet*vx;
    vx=vx+ax*dt;
    svx=sign(vx);
    x(i)=x(i-1)+vx*dt;
    ec(i)=vx^2/2;
    ep(i)=kk*fr(i)^2/2;
    w(i)=kk*(x(i)-fr(i))*vx;
end

fprintf('Potenza media: %f \n',mean(w));
g=gd(x);
g=edit_gd(g,'dx',dt,'capt','moto carrello con molla');

ec=gd(ec);
ec=edit_gd(ec,'dx',dt,'capt','energia cinetica');

ep=gd(ep);
ep=edit_gd(ep,'dx',dt,'capt','energia potenziale');

w=gd(w);
w=edit_gd(w,'dx',dt,'capt','potenza');

Ns=floor(N/ss);
i20=20;
s=zeros(1,Ns+i20);
s(i20+1:Ns+i20)=x(round((1:Ns)*ss));

s=gd(s);
s=edit_gd(s,'dx',data.st,'ini',-i20*data.st+(ss-1)*dt,'capt','campioni moto carrello con molla');

mot=gd(fr);
mot=edit_gd(mot,'dx',dt);

if ifr == 0
    g1=0;
    return
end

ddt=dt/10;
N=N*10;
nn=0;
if fr0 > 0
    nn=round(1/(fr0*ddt));
    ddt=1/(fr0*nn);
    N=round(N*dt/(ddt*10));
end

if fr0 ~= 0
    fr=sin(fr0*2*pi*(0:N-1)*ddt);
else
    fr=(0:N-1)*0;
end

x=zeros(N,1);
vx1=x;
x(1)=x0;
vx=data.v0;
kk=data.kmolla/data.massa;
bet=data.beta/data.massa;
cost=data.muv/data.massa;
svx=sign(vx);
nsm=round(data.tsmooth/ddt);
fr(1:nsm)=fr(1:nsm).*(1-cos(pi*(1:nsm)/nsm))/2;
fr=fr*data.A;

for i = 2:N
    ax=-kk*(x(i-1)-fr(i-1))-svx*cost-bet*vx;
    vx=vx+ax*ddt;
    svx=sign(vx);
    x(i)=x(i-1)+vx*ddt;
    vx1(i)=vx;
end

if nn > 0 & data.modo == 0
    N1=floor(N/nn);
    ec1=zeros(N1,1);
    ep1=ec1;
    w1=ec1;
    dis1=ec1;
    j=0;
    for i = 1:nn:N
        j=j+1;
        ec1(j)=sum(vx1(i:i+nn-1).^2/2)*ddt;
        ep1(j)=sum(kk*(x(i:i+nn-1)-fr(i:i+nn-1)').^2/2)*ddt;
        w1(j)=sum(kk*fr(i:i+nn-1)'.*vx1(i:i+nn-1))*ddt;
        dis1(j)=sum(data.beta*(vx1(i:i+nn-1)).^2+data.muv*vx1(i:i+nn-1).*sign(vx1(i:i+nn-1)))*ddt;
    end
    
    ec1=gd(ec1);
    ec1=edit_gd(ec1,'dx',ddt*nn,'capt','energia cinetica per periodo');

    ep1=gd(ep1);
    ep1=edit_gd(ep1,'dx',ddt*nn,'capt','energia potenziale per periodo');

    w1=gd(w1);
    w1=edit_gd(w1,'dx',ddt*nn,'capt','potenza per periodo');
end

g1=gd(x);
g1=edit_gd(g1,'dx',ddt,'capt','moto carrello con molla enh.');

if data.modo == 0
    figure,plot(mot,'g');hold on,plot(g);plot(g1,'r');plot(s,'.');
    title(sprintf('%f Hz',fr0)),xlabel('s')
    figure,plot(ec);hold on,plot(ep,'g');plot(ec+ep,'r');
    title(sprintf('Energia cin (b), pot (g), tot (r) @ %f Hz',fr0)),xlabel('s')
    figure,plot(w);
    title(sprintf('Potenza analitica @ %f Hz',fr0)),xlabel('s')
    if nn > 0
        figure,plot(ec1,'c');hold on,plot(ep1,'r');plot(ec1+ep1,'g');
        plot(ec1,'.');hold on,plot(ep1,'g.');plot(ec1+ep1,'r.');
        title(sprintf('Energia/per cin (b), pot (g), tot (r) @ %f Hz',fr0)),xlabel('s')
        figure,plot(w1,'y');hold on,plot(w1,'r.');
        plot(deri_gd(ec1+ep1),'c');plot(deri_gd(ec1+ep1),'.');
        title(sprintf('Potenza/per (r) e Input energy (b) @ %f Hz',fr0)),xlabel('s')
        figure,plot(w1-deri_gd(ec1+ep1)),hold on,plot(w1-deri_gd(ec1+ep1),'m.')
        plot(dis1,'c'),plot(dis1,'.')
        title(sprintf('Potenza analitica/per (m) e diss/per (b) @ %f Hz',fr0)),xlabel('s')
    end
end
function [g,s,ep,ec,w,mot,g1]=esp_carr_molla1(fr,data)
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
fr=fr*data.A;

for i = 2:N
    ax=-kk*(x(i-1)-fr(i-1))-svx*cost-bet*vx;
    vx=vx+ax*dt;
    svx=sign(vx);
    x(i)=x(i-1)+vx*dt;
    ec(i)=vx^2/2;
    ep(i)=kk*(x(i)-fr(i))^2/2;
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

if fr0 ~= 0
    fr=sin(fr0*2*pi*(0:N-1)*ddt);
else
    fr=(0:N-1)*0;
end

x=zeros(N,1);
x(1)=x0;
vx=data.v0;
kk=data.kmolla/data.massa;
bet=data.beta/data.massa;
cost=data.muv/data.massa;
svx=sign(vx);
fr=fr*data.A;

for i = 2:N
    ax=-kk*(x(i-1)-fr(i-1))-svx*cost-bet*vx;
    vx=vx+ax*ddt;
    svx=sign(vx);
    x(i)=x(i-1)+vx*ddt;
end

g1=gd(x);
g1=edit_gd(g1,'dx',ddt,'capt','moto carrello con molla enh.');

if data.modo == 0
    figure,plot(mot,'g');hold on,plot(g);plot(g1,'r');plot(s,'.');
    title(sprintf('%f Hz',fr0)),xlabel('s')
    figure,plot(ec);hold on,plot(ep,'g');plot(ec+ep,'r');
    title(sprintf('Energia cin (b), pot (g), tot (r) @ %f Hz',fr0)),xlabel('s')
    figure,plot(w);
    title(sprintf('Potenza @ %f Hz',fr0)),xlabel('s')
end
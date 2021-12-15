function tfps=gd_tpows(g,Dt,df,res)
% GD_TPOWS  time-frequency power spectrum (only for type 1 gd)
%
%     tfps=gd_tpows(g,dt,df,res)
%
%    g     input gd
%    Dt    time step (0 if df is defined)
%    df    frequency step (without over-resolution; only if Dt = 0)
%    res   over-resolution (> 1; 1 = natural)

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

dt=dx_gd(g);
t0=ini_gd(g);
n=n_gd(g);
y=y_gd(g);

if Dt == 0
    Dt=1/df;
end

nt=2*round(0.5*Dt/dt);
nt2=nt/2;
nt1=round(nt*res);
nf=nt1;
ir=0;
if isreal(y)
    nf=ceil(nf/2);
    ir=1;
end
Nt=floor(n/nt2)-1;
tfps=zeros(Nt,nf);
w=pswindow('hanning',nt);
i=0;
j=0;

while i <= n-nt
    j=j+1;
    x=y(i+1:i+nt);
    x=x.*w.';
    xm=mean(x)*ir;
    x=x-xm;
    x(nt+1:nt1)=0;
    x=fft(x);
    tfps(j,:)=abs(x(1:nf)).^2*dt/nt;
    i=i+nt2;
end

tfps=gd2(tfps);
tfps=edit_gd2(tfps,'ini',t0,'dx',nt2*dt,'dx2',1/(dt*nt1),'capt','time-frequency power spectrum');
function tfps=gd_tfrps(g,lfft,nover,res,win)
% GD_TFRPS  time-frequency power spectrum (only for type 1 gd)
%             (see also gd_tpows)
%
%     tfps=gd_tpows(g,dt,df,res)
%
%    g      input gd
%    lfft   length of ffts in samples (even)
%    nover  number of samples for overlapping (1 -> lfft/2)
%    res    over-resolution (> 1; 1 = natural)
%    win    window  (0 -> no, 1 -> bartlett, 2 -> hanning (def), 3 -> flatcos, 4 -> tukey)

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza Rome University

if ~exist('win','var')
    win=2;
end

lfft=floor(lfft/2+1)*2;

if nover == 0
    nover=lfft/2;
end

dt=dx_gd(g);
n=n_gd(g);
y=y_gd(g);

Dt=nover*dt;

nt=2*round(0.5*Dt/dt);
nt2=nt/2;
nt1=round(nt*res);
nf=lfft;
ir=0;
if isreal(y)
    nf=ceil(nf/2);
    ir=1;
end
Nt=floor(n/lfft)-1;
tfps=zeros(Nt,nf);
dfr=1/(dt*lfft);
w=pswindow(win,lfft);
i=0;
j=0;

while i <= n-lfft
    j=j+1;
    x=y(i+1:i+lfft);
    x=x.*w.';
    xm=mean(x)*ir;
    x=x-xm;
    x(nt+1:nt1)=0;
    x=fft(x);
    tfps(j,:)=abs(x(1:nf)).^2*dt/nt;
    i=i+nover;
end

tfps=gd2(tfps);
tfps=edit_gd2(tfps,'dx',Dt,'dx2',dfr,'capt','time-frequency power spectrum');
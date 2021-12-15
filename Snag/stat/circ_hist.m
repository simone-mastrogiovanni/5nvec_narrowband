function [his,his1,ww,holes,win1,ana]=circ_hist(dat,T,tbias,dt,nbin,win,enl)
% generalized circular histogram
%
%    dat     data samples
%    T       period (negative -> analysis)
%    tbias   phase bias (t units)
%    dt      sampling interval
%    nbin    number of bins in the (basic) period
%    win     semi-window (decrescent, in enlarged time) 
%            if single number, type (1 triagular)
%    enl     enlargement factor (default 10)

% Snag Version 2.0 - May 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('enl','var')
    enl=10;
end

icana=0;
if T < 0
    T=-T;
    icana=1;
end

if length(win) == 1
    switch win
        case 1
            lw=enl;
            win=lw:-1:1;
            win=win/lw;
    end
else
    lw=length(win);
end

LW=2*lw-1;
win1(lw:LW)=win;
win1(1:lw-1)=win(lw:-1:2);

nbin1=nbin*enl;
pp=zeros(1,nbin1);
ww=pp;
n=length(dat);

t=tbias+(0:n-1)*dt;

t=mod(t,T);
t=floor(t*nbin1/T)+1; 

for ij = 1:nbin1
    i1=find(t == ij);
    pp(ij)=mean(dat(i1));
    ww(ij)=mean(sign(dat(i1)));
end

holes=find(ww == 0);
if ~isempty(holes)
    fprintf(' *** %d holes \n',length(holes))
end
his2=pp./ww;
nbin2=nbin1+LW-1;
his2(nbin1+1:nbin2)=0;

his2=filter(win1,1,his2);
his2(1:LW-1)=his2(1:LW-1)+his2(nbin1+1:end);
his2=his2(1:nbin1);
% his1=his2(lw:nbin1);
% his1(nbin1-lw+1:nbin1)=his2(1:lw);
his1=rota(his2,-lw+1);

his=his1(1:lw:nbin1);

if icana > 0
    f=fft(his-mean(his));
    f1=fft(his1-mean(his1));
    a=ifft(abs(f).^2);
    a1=ifft(abs(f1).^2);
    
    figure,plot(his),hold on,plot(his,'r.'),grid on,title('histogram')
    figure,plot(his1),hold on,plot(his1,'r.'),grid on,title('enlarged histogram')
    
    figure,semilogy(abs(f)),hold on,semilogy(abs(f),'r.'),grid on,title('fourier')
    figure,semilogy(abs(f1)),hold on,semilogy(abs(f1),'r.'),grid on,title('enlarged fourier')
    
    figure,plot(a),hold on,plot(a,'r.'),grid on,title('autocorrelation')
    figure,plot(a1),hold on,plot(a1,'r.'),grid on,title('enlarged autocorrelation')
    
    ana.f=f;
    ana.f1=f1;
    ana.a=a;
    ana.a1=a1;
else
    ana=[];
end
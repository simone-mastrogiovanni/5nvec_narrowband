function [phtim_f phtim phtim1 phtim0 win period]=gd2_period_ns(g2in,per,ph,nbin,subband,tau,step,tit)
% gd2_period_ns  epoch folding with a gd2, non-stationary
%
%   [phtim phtim0 win period]=gd2_period_ns(g2in,per,ph,nbin,subband)
%
%   g2        input gd
%   per       period (number,if string, time in mjd)
%                "day" "week" "sid" 
%   ph        phase; for per = 'sid', ph = antenna gives the loc sid time
%   nbin      number of bins in the period (def = 48; 0 -> def)
%   subband   [minfr maxfr] ; =0 all
%   tau       non-stationarity window (in x1 units)
%   step      time step (in periods; possibly integer)
%
%   phtim     phase time map
%        0    windows normalized
%        1    then mean normalized
%             then smoothed and interpolated for holes on the hours
%        _f   then filtered
%   win       window map

% Version 2.0 - January 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

tsid0=51544.7203396;

if ~exist('tit','var')
    tit='';
end

if ~exist('nbin','var')
    nbin=48;
end

if nbin == 0
    nbin=48;
end

if ~exist('subband','var')
    subband=0;
end

M=y_gd2(g2in);
[n m]=size(M);
t=x_gd2(g2in);
x2=x2_gd2(g2in);
dx2=dx2_gd2(g2in);

T=t(n)-t(1);

if ischar(per)
    switch per
        case 'day'
            per=1;
            icper=1;
            strtit='One day period';
        case 'week'
            per=7;
            icper=3;
%             ph=360*5/7;
            strtit='One week period';
        case 'sid'
            per=1/1.002737909350795;
            strtit='Sidereal day period';
            if ~isnumeric(ph)
                long=ph.long;
            else
                long=0;
            end
            icper=2;
        case 'asid'
            per=1/(2-1.002737909350795);
            strtit='Anti-Sidereal day period';
            if ~isnumeric(ph)
                long=ph.long;
            else
                long=0;
            end
            icper=4;
    end
else
    strtit=sprintf('Period %f',per);
end

N=floor(T/step);
N1=2*N;
N1=round(N1/4)*4;
N4=N1/4;

phtim=zeros(nbin,N);
phtim0=phtim;
phtim1=phtim;
phtim_f=phtim;
win=phtim+1.e-6;
phas=zeros(1,N);
amp=phas;

icper=0;
nasc=360;

if length(subband) == 2
    jjj=find(x2 >= subband(1) & x2 <= subband(2));
    if isempty(jjj)
        fprintf('\n *** Incorrect frequency range (%f %f) instead of (%f %f) \n\n',subband,min(x2),max(x2));
        return
    end
    m1=min(jjj);
    m2=max(jjj);
    if nofig == 0
        fprintf(' m range: %d %d \n',m1,m2)
    end
else
    m1=1;m2=m;
end

g1=gd2_to_gd_norm(g2in,0,[m1 m2]);

g1=find(g1);
t1=x_gd(g1);
t0=floor(t1(1));
y1=y_gd(g1);
g1=y_gd(g1);
nn=length(g1);

ini2=x2(m1);

switch icper
    case 1
        t1=t1-t0;
        i1=floor(mod(t1,1)*nbin)+1;
        nasc=24;
    case 2
%         t1=(gmst(t1)*15+long)/360;
        t2=t1-tsid0+long/360;
        i1=floor(mod(t2/per,1)*nbin)+1;
        t1=t1-t0;
        nasc=24;
    case 4
        t1=agmst(t1)*15/360;
        i1=floor(mod(t1/per,1)*nbin)+1;
        nasc=24;
    otherwise
        t1=t1-t0;
        i1=floor(mod(t1/per,1)*nbin)+1;
end

perstep=per*step;
i2=ceil(t1/(perstep));%figure,plot(i1,i2,'.'),%nn,return

for i = 1:nn
    i22=i2(i);
    if i22 > N
        i22=N;
    end
    phtim0(i1(i),i22)=phtim0(i1(i),i22)+g1(i);
    win(i1(i),i22)=win(i1(i),i22)+1;
end

phtim0=phtim0./win;

% plot_stat(phtim0,nbin,['[phtim0] ' tit ' ' strtit]);

for i = 1:N
    ii=find(phtim0(:,i));
    if ~isempty(ii)
        me=mean(phtim0(ii,i));
        phtim1(ii,i)=phtim0(ii,i)/me;
    end
end

for i = 1:N
    phtim(:,i)=fitper_sf(phtim1(:,i),4);
end

sigt=tau/perstep;
sigf=1/sigt;
lpt=((0:N1-1)*2*pi/N1)/sigf;
lp=exp(-lpt.^2/2);
NN=ceil(N1/2)-1;
lp(N1:-1:N1-NN+1)=lp(2:NN+1);
if floor(N1/2)*2 == N1
    lp(NN+2)=0;
end

app=zeros(1,N1);
norm0=app;
norm0(N4+1:N4+N)=1; % figure

for i = 1:nbin
    norm1=norm0;
    ii=find(win(i,:) < 0);
    norm1(ii)=0;
    f=fft(norm1).*lp;
    norm1=ifft(f);
    
    app(N4+1:N4+N)=phtim(i,:)-1;
    f=fft(app).*lp;
    f=ifft(f)./norm1+1;
    phtim_f(i,:)=f(N4+1:N4+N);
%     plot(norm/max(norm1)),hold on,plot(f/max(f),'r'),plot(phtim(i,:),'g'),hold off,pause(0.5)
%      plot(norm1(N4+1:N4+N)/max(norm1)),hold on,plot(f(N4+1:N4+N)/max(f),'r'),hold off,pause(0.5)
%     if max(f) > 1
%         plot(norm1(N4+1:N4+N)),hold on,plot((f(N4+1:N4+N)-1)/max(f-1),'r'),pause(0.5)
%     end
%    plot(f(N4+1:N4+N)/max(f)),pause(0.5)
end

% plot_stat(phtim1,nbin,['[phtim1] ' tit ' ' strtit]);
% plot_stat(phtim,nbin,['[phtim] ' tit ' ' strtit]);
period=plot_stat(phtim_f,nbin,['[phtim-f] ' tit ' ' strtit]);

for i = 1:N
    [cc ii]=max(phtim_f(:,i));
    amp(i)=(cc-min(phtim_f(:,i)))/2;
    phas(i)=(ii-1)*24/nbin;
end

figure
tt=(0.5:N)*perstep;
subplot(2,1,1),plot(tt,amp),grid on,xlabel('time (days)'),ylabel('Amplitude'),xlim([tt(1) tt(length(tt))])
title([tit ' ' strtit])
subplot(2,1,2),plot(tt,phas),grid on,xlabel('time (days)'),ylabel('Phase'),xlim([tt(1) tt(length(tt))]),ylim([0 24])

phtim0=gd2(phtim0');
phtim0=edit_gd2(phtim0,'dx2',24/nbin,'ini',perstep/2,'dx',perstep);

phtim1=gd2(phtim1');
phtim1=edit_gd2(phtim1,'dx2',24/nbin,'ini',perstep/2,'dx',perstep);


phtim=gd2(phtim');
phtim=edit_gd2(phtim,'dx2',24/nbin,'ini',perstep/2,'dx',perstep);

phtim_f=gd2(phtim_f');
phtim_f=edit_gd2(phtim_f,'dx2',24/nbin,'ini',perstep/2,'dx',perstep);

image_gd2(real(phtim_f)),grid on,xlabel('time (days)'),ylabel('hours')

if exist('tit','var')
    title([tit  ' ' strtit])
end



function period=plot_stat(phtim,nbin,tit)

period=zeros(nbin,1);

for i = 1:nbin
    period(i)=mean(phtim(i,:));
end

period=period/mean(period); 
period=gd(period);
period=edit_gd(period,'dx',24/nbin);
epfol_plotnfit(period,4);
xlabel('hours')

if exist('tit','var')
    title([tit ' mean of phtim'])
end

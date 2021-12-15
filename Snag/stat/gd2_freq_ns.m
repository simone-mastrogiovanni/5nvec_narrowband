function [frtim_f frtim frtim0 g1]=gd2_freq_ns(g2in,fr3,subband,tau,step,tit,iclog)
% gd2_freq_ns  power spectrum with a gd2, non-stationary
%
%   [frtim_f frtim]=gd2_freq_ns(g2in,fr,subband,tau,step,tit)
%
%   g2        input gd
%   fr3       frequency [frin dfr frfin] (typically days^-1)
%   subband   [minfr maxfr] ; =0 all
%   tau       non-stationarity window (in x1 units)
%   step      time step (days)
%   tit       title
%   iclog     0 normal, 1 log, 2 sqrt map
%
%   frtim     frequency time map
%   frtim_f   frequency-time map (filtered)
%

% Version 2.0 - January 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('tit')
    tit='';
end

tit=underscore_man(tit);

if ~exist('iclog')
    iclog=0;
end

if ~exist('nbin')
    nbin=48;
end

if nbin == 0
    nbin=48;
end

if ~exist('subband')
    subband=0;
end

M=y_gd2(g2in);
[n m]=size(M);
t=x_gd2(g2in);
x2=x2_gd2(g2in);
% dx2=dx2_gd2(g2in);

fr=fr3(1):fr3(2):fr3(3);
nbin=length(fr);
dfr=fr3(2);
frin=fr3(1);
frfin=fr3(3);

t0=floor(t(1));
T=t(n)-t(1);
nday=ceil(t(n)-t0);

N=ceil(nday/step);
N1=2*N;
N1=round(N1/4)*4;
N4=N1/4;

frtim=zeros(nbin,N);
frtim0=frtim;
frtim_f=frtim;
numdat=zeros(1,N);

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
y1=y_gd(g1);
% nn=length(g1);
% ii=0;

i1=floor((t1-t0)/step)+1;

for i = 1:N
    ii=find(i1 == i);
    numdat(i)=length(ii);
    if ~isempty(ii)
        g11=gd(y1(ii));
        g11=edit_gd(g11,'x',t1(ii));
        frtim0(:,i)=y_gd(gd_holeps(g11,fr)); %figure,plot(gd_holeps(g11,fr))
        frtim(:,i)=frtim0(:,i)/mean(g11)^2;
    end
end

if N > 1
    figure,plot(numdat),grid on,xlim([1 N]),title('Number of data for each segment')
else
    fprintf('numdat = %d \n',numdat(1));
    figure,plot(fr,frtim(:,1)),grid on
    frtim_f=0; frtim=0; g1=0;
    return
end

sigt=tau/step;
sigf=1/sigt;
lpt=((0:N1-1)*2*pi/N1)/sigf;
lp=exp(-lpt.^2/2);

NN=ceil(N1/2)-1;
lp(N1:-1:N1-NN+1)=lp(2:NN+1);
if floor(N1/2)*2 == N1
    lp(NN+2)=0;
end

app=zeros(1,N1);
norm1=app;
norm1(N4+1:N4+N)=1;

f=fft(norm1).*lp;
norm1=ifft(f);

for i = 1:nbin
    app(N4+1:N4+N)=frtim(i,:);
    f=fft(app).*lp;
    f=ifft(f)./norm1;
    frtim_f(i,:)=f(N4+1:N4+N);
end

for i = 1:N
    [cc ii]=max(frtim_f(:,i));
    amp(i)=(cc-min(frtim_f(:,i)))/2;
    freq(i)=(ii-1)*dfr+frin;
end

figure
tt=(0.5:N)*step;
subplot(2,1,1),plot(tt,amp),grid on,xlabel('time (days)'),ylabel('Amplitude'),xlim([tt(1) tt(length(tt))])
title(tit)
subplot(2,1,2),plot(tt,freq),grid on,xlabel('time (days)'),ylabel('Frequency (days^{-1})'),xlim([tt(1) tt(length(tt))]),ylim([frin frfin])

frtim=gd2(frtim');
frtim=edit_gd2(frtim,'dx2',fr(2),'ini2',frin,'ini',step/2,'dx',step);

frtim_f=gd2(frtim_f');
frtim_f=edit_gd2(frtim_f,'dx2',dfr,'ini2',frin,'ini',step/2,'dx',step);

image_gd2(real(frtim_f),0,iclog),grid on,xlabel('time (days)'),ylabel('Frequency (days^{-1})')

if exist('tit','var')
    title(tit)
end
function pm=pss_sim_pm_lr(ant,sour,pmstr,doptab,nois,level,tfspec)
%PSS_SIM_PM  peak map simulation, low resolution
%
%    ant     antenna structure; elments used:
%             .lat    latidude   (degrees)
%             .long   longitude  (degrees)
%             .azim   azimuth    (degrees)
%             .type   type (1 -> bar, 2 -> interferometer)
%    sour    source structure array; elments used:
%             .a      right ascension  (degrees)  
%             .d      declination      (degrees)
%             .eps    fraction of linear polarization power
%             .psi    angle of linear polarization
%             .t00    frequency epoch (tipically v2mjd([2000,1,1,0,0,0]))
%             .f0     un-Dopplered frequency at start time
%             .df0    coefficient of first power spin-down (Hz/day)
%             .ddf0   coefficient of second power spin-down (Hz/day^2)
%             .snr    signal-to-noise ratio (linear; supposing white noise)
%    pmstr   peak map property structure
%         .dt      sampling time (s)
%         .lfft    fft length
%         .frin    initial frequency
%         .nfr     number of frequency bins
%         .res     spectral resolution (in normalized units)
%         .t0      initial time (mjd)
%         .np      number of periodograms
%         .thresh  threshold (typically 2)
%         .win     window type (0 -> no, 1 -> pss);
%    doptab  Doppler table (created by ...)
%            table containing the Doppler data (depends on antenna and year)
%            (a matrix (n*4) or (n*5) with:
%                first column       containing the times (normally every 10 min)
%                second col         x (in c units, in equatorial cartesian frame)
%                third col          y
%                fourth col         z
%    nois    a pmstr.np array with noise levels, in st.dev.; if the dimension is not
%            exact, the value 1 is given for all the periodograms
%    level   simulation level:
%                1   no sid modulation, direct frequency computation, res=1
%                2   sid modulation, direct frequency computation, res=1
%                3   no sid modulation, fft frequency computation
%                4   sid modulation, fft frequency computation
%    tfspec   if = 1, time-frequency spectrum, otherwise only peak map; default 0 
%
%    pm      output peak map structure
%      .np      number of periodograms
%      .frin    initial frequency
%      .nfr     number of frequency bins
%      .dt      sampling time (s)
%      .lfft    fft length
%      .dfr     frequency bin width
%      .res     spectral resolution (in normalized units)
%      .t0      initial time (mjd)
%      .thresh  threshold (typically 2)
%      .win     window type (0 -> no, 1 -> pss);
%      .t(:)    periodograms time
%      .v(:,3)  periodograms detector velocity
%      .st(:)   periodograms sidereal time
%      .nois(:) periodograms noise
%      .PM      peak map (sparse matrix, fr:t)
%
%
%           Operation
%
%  See start_pss_sim_pm_lr.m

% Version 2.0 - June 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

deg_to_rad=pi/180;
np=pmstr.np;

if ~exist('nois')
    nois=ones(np,1);
else
    if length(nois) ~= np
        disp(' *** stationary noise !');
        nois=ones(np,1);
    end
end
nois=nois(:);
        
if ~exist('tfspec')
    tfspec=0;
end

if ~exist('level')
    level=1;
end

levsid=0;
if level == 2 | level == 4
    levsid=1;
end

levfft=0;
if level == 3 | level == 4
    levfft=1;
else
    pm.res=1;
end

pm=pmstr;
pm.dfr=1/(pm.lfft*pm.dt);
DT=pm.dt*pm.lfft/(pm.res*2*86400); % 2 is for interlaced periodograms
nfr=pm.nfr;
ndat=round(nfr/pm.res)*2           % number of t-samples in a (reduced) fft
dt=1/(2*pm.dfr*nfr)                % (reduced) sampling time
thr=pm.thresh;

pm

powgain=pm.lfft/(nfr*2);
lingain=sqrt(powgain);

t=(0:np-1)*DT+pm.t0;
t1=t+DT/2;

v(:,1)=spline(doptab(1,:),doptab(2,:),t1)';
v(:,2)=spline(doptab(1,:),doptab(3,:),t1)';
v(:,3)=spline(doptab(1,:),doptab(4,:),t1)';

ns=length(sour);

for i=1:ns
	as=sour(i).a*deg_to_rad;
	ds=sour(i).d*deg_to_rad;
    
    xs=cos(ds).*cos(as);
	ys=cos(ds).*sin(as);
	zs=sin(ds);
	
	vcosfi=v(:,1)*xs+v(:,2)*ys+v(:,3)*zs;
	
	dop=1+vcosfi;
    f0=sour(i).f0;
    df0=sour(i).df0;
    ddf0=sour(i).ddf0;
    t00=sour(i).t00;
    f=(f0-df0*(t1-t00)+ddf0*(t1-t00).^2/2).*dop'-pm.frin;
    fr(1:np,i)=f.';
    
    if levsid == 1
        tsid=gmst(t1);
        f=sqrt(radpat_interf(sour(i),ant,tsid));
    else
        f=ones(1,np);
    end
    snr(:,i)=lingain*sour(i).snr*f'./nois;
end

win=ones(ndat,1);  figure,plot(fr(:,1)),hold on, plot(fr(:,2),'r')
if pm.win == 1
    n4=round(ndat/4);
    win(1:n4)=(1-cos(pi*(0:n4-1)/n4))/2;
    win(ndat:-1:ndat-n4+1)=win(1:n4);
end
win=win.';
winc=mean(win.^2);

npeaktot=0; 
%aaa=zeros(nfr,np); % !!!!
sqr2=sqrt(2); %figure,pm.dt,fr

if tfspec == 1
    A=zeros(nfr,np);
end

res_nfr=pm.res/(2*nfr);

for k = 1:pm.np
    if levfft == 1
        y=randn(1,ndat);
        for i = 1:ns
            y=y+snr(k,i).*cos(2*pi*fr(k,i)*(1:ndat)*dt); %snr(k,i)
        end
		y=y.*win;
		y(ndat+1:2*nfr)=0;
		y=fft(y);
		y=abs(y(1:nfr)).^2*res_nfr;  %semilogy(y), pause
        y=y.'/winc;
    else
        y=complex(randn(nfr,1),randn(nfr,1))/sqrt(2);
     %   y=complex(zeros(nfr,1),zeros(nfr,1))/sqrt(2); % !!!!
        for i = 1:ns
            is=floor(fr(k,i)/pm.dfr)+1; aaa(k)=is;
            if is > 0 & is <= nfr
%                 y(is)=y(is)+snr(k,i)*sqrt(ndat)/2;
                y(is)=y(is)+10*sqrt(ndat)/2;
            end
        end
        y=y.*conj(y);
    end
    %mean(y)
    if tfspec ~= 1
        y1=rota(y,1); % figure, plot(y), pause
        y2=rota(y,-1);
        y1=ceil(sign(y-y1)/2);
        y2=ceil(sign(y-y2)/2);
        y1=y1.*y2;
        y=y.*y1;
        y2=ceil(sign(y-thr)/2);
        y=y.*y2;
        npeak=sum(y2);
        [i1,j1,s1]=find(y);
        i2(npeaktot+1:npeaktot+npeak)=i1;
        j2(npeaktot+1:npeaktot+npeak)=k;
        s2(npeaktot+1:npeaktot+npeak)=s1;
        npeaktot=npeaktot+npeak;
    else
        A(:,k)=y;
    end
end

% figure,plot(dop)
% figure,plot(fr(1,:)),pm.dfr % !!!!
% figure,plot(aaa) % !!!!

if tfspec ~= 1
	npeaktot
	figure,plot(j2,i2,'+'), grid on
	figure,semilogy(i2,s2,'+'), grid on
    title('spectral amplitudes as a function of frequency')
	%figure,plot(j2,s2,'+')
	A=sparse(i2,j2,s2,nfr,pm.np);
	figure;
	spy(A);
else
    figure
    image(log(A));  grid on
end

pm.PM=A;
pm.v=v;
pm.t=t;

pm.st=gmst(t1);
pm.nois=t1*0+1;

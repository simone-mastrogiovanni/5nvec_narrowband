function [xp_tot,yp_tot,zp_tot,hdf1,dfr,frband]=pia_creahfdf_anaparsp_sf(res,edge,dmin,dmax,kdeltaf)
%PIA_creahfdf from a vbl-file peakmap creates, using pia_creatimfr, a hough
%tranformation to the plane (f0,fdot)
%
% In a vbl-file the first channel is the parameters, the second the bins,
% the third the amplitudes; other channels can contain short spectra and
% other.
%
%   res  =0  -->1
%   edge   <=0  -->0.00001
%   dmin,dmax  min,max spindown values. Hz/s; =0  0--> dmin=-0.1  dmax=0.1
%   ATTENZIONE: 0,0 default su d va bene solo ora per le mie prove. Dovremo
%   fare diversamente !!!  Sergio e' d'accordo ! 24/08/07
% kdeltaf = factor to get, from dfr, the deltaf bandwith over which to look for f0
% =0 -->1 used for instrumental disturbances
%
%   frband         bandwidth of the signal
%   dfr            frequency resolution, Hz
%   hdf0           output (a gd2 , with f0 and fdot )
% Version xx - 8 October 2007
% by Pia
% E.g. 
%      [xp_tot,yp_tot,zp_tot,hdf1,dfr,frband]=pia_creahfdf_anaparsp_sf(10,0,0,0,0);
% cd c:\matlab\hough-pia

%% programma

format long

MAXLOOP=20   %number of loops around the true spin-down

nloop=MAXLOOP;
imin=-round(nloop/2);
imax=-imin;

if edge <= 0
    edge=0.00001;
end

dt=1000;
n=500;
dfr=0.001;
nfr=1000;
inifr=49.5;
observation_time=(n-1)*dt;

step_sd=dfr/observation_time
% step_sd=2.5e-7/5;

%% sorgente

DTRUE=step_sd*25
% DTRUE=1e-7
lines(1).fr=50;
lines(1).d=DTRUE;
lines(1).amp=1000;
par.nt=n;
par.nfr=nfr;
par.dt=dt;
par.dfr=dfr;
par.inifr=inifr;
par.thresh=40; lines,par

timfr_sim=crea_linpm(lines,par); % plot(timfr_sim)

A=y_gd2(timfr_sim); 
[ff,tt,aa]=find(A');
% frini=ini_gd2(timfr_sim)
ff=(ff-1)*dfr+inifr;  %IMPORTANTE !! Per come funziona linpm
tt=(tt-1)*dt;
nt=n/nfr;              

tim_tot=tt-min(tt);
freq_tot=ff;
observation_time=max(tim_tot)
n_of_ff=length(ff);

peaks(2,:)=ff;
peaks(1,:)=tim_tot;%plot(peaks(1,:),peaks(2,:),'.'),grid on
a=inifr-round(nfr/2)*dfr; 
b=inifr+round(2*nfr/2)*dfr;  %corretto 11/10/07 Era nfr-1
f0band=[a b]   %per prova attenzione ! !! METTERE IN INPUT
% f0band=[40 100]


%% mappa di Hough


scale=2*10^6;  %%factor which multiplies deltad, when used...
if res == 0
    res=1.0;
end

%Deltad is the spin-down resolution. Depends on the observation time
% 2 ottobre 07: put to a value convenient for crea_linpm --simulation

deltad= scale*dfr/observation_time  %%uncomment for true analyses
deltad=step_sd;

if (dmin==0 && dmax==0)
    dmin=-150*deltad;
    dmax=-dmin;
end

thr=0;
time=0;
%Read the time-frequency gd and creates two vectors and parameters
% AND 
%Set parameters, using the information read in the peakmap and given in noput

%% casini vari sulla banda

factor=1;
if dmax < 0
    factor=0;
end
if kdeltaf==0
     kdeltaf=1;
end
frband(1)=f0band(1)*(1-edge)-factor*observation_time*dmax;
if frband(1) < 0
    frband(1)=0;
end
factor=1;
if dmin > 0
    factor=0;
end
frband(2)=f0band(2)*(1-edge)-factor*observation_time*dmin;
if frband(2) > nfr*dfr+inifr            %%Attenzione: per ora viene sempre cosi', frband=f0band 
    frband(2)=nfr*dfr+inifr             %%11 ott 07 per come ho fatto su f0_band. Capire,cambiare
end
f0band,frband
% f0_central=(f0band(2)-f0band(1))/2
%f0_res is the resolution for f0:
f0_res=dfr/res;
clear timfr_sim
%Deltaf is the bandwidth around freq on which to look to construct f0
deltaf= dfr*kdeltaf
%%%%%%%%%Evaluation of the number of bins and inizialization (=0)of the bin contents in the differential histogram%%%%%%%%%%%%%%%%

nbin_f0=round((f0band(2)-f0band(1))/f0_res);
% nbin_fr=round((frband(2)-frband(1))/dfr);


%% Altri casini

% dmin0=dmin+imin*deltad/nloop;   %Minumum of all the used dmin
% dmax0=dmax+imax*deltad/nloop;   %Max of all the used dmax  
dmin0=dmin-deltad/2;   %Minumum of all the used dmin
dmax0=dmax+deltad/2;   %Max of all the used dmax
%Bins of d  related to dmin and dmax, or to dmin0 and dmax0 ??
nbin_d=round((dmax-dmin)/deltad)
lenyy=imin*2+1;
yya=zeros(1,lenyy);
xx=yya;
yyf=yya;
yyd=yya;
iloop=imin;

%Begin of the two loops
fac=1/100000;
iii=0;

hmap.fr=[f0band(1) deltaf res nbin_f0];%plot(peaks(1,:),peaks(2,:),'.'),grid on


%% loop

while iloop <= imax
    iii=iii+1;
    dmin1=dmin+iloop*deltad/nloop;
    xx(iii)=dmin1;
    hmap.d=[dmin1 deltad nbin_d];
   
    hdf0=hfdf_hough(hmap,peaks); %,plot(hdf0),hmap,plot(peaks(1,:),peaks(2,:),'.'),grid on,return
    
    if iloop == 0
        hdf1=hdf0;
    end
    if iloop == imin
        figure
        hist(ff,1000); %%Istogram of the original peakmap in the selected band
        grid on
    end
    if abs(iloop) <= 1    %%Three figures for example 
        plot(hdf0)
        xlabel('f_0 [Hz]')
        ylabel('spin-down [Hz/s]')
        if iloop == 0
            title('Recovered with exact spin down value. iloop 0')
        end
    end
    thres=20;
    nmax=100;
    [xp,yp,zp]=twod_peaks(hdf0,thres,nmax,1);
    yya(iii)=zp(1);
    yyf(iii)=xp(1);
    yyd(iii)=yp(1);
    if iloop == 0
        figure
        plot(zp,xp,'*b')
        ylabel('f_0')
        xlabel('Intensity of the max')
        grid on
        figure
        plot(zp,yp,'*r')
        ylabel('spin down')
        xlabel('Intensity of the max')
        grid on
        figure
        plot3(xp,yp,zp,'*r')
        grid on
        if iloop == 0
            title('Peaks on hdf0 found with twod-peaks. iloop=0')
        end
        xlabel('f_0')
        ylabel('spin-down')
        zlabel('Intensity of the max')
    end
    
    nshow=length(xp);
    if nshow >= 3
       nshow =3;
    end
    iloop
    show_twod_peaks(xp,yp,zp,nshow);
    acc=(DTRUE-dmin1)/deltad;
    acc=round(acc)*deltad+dmin1;
    disp(sprintf('%12.9f  %12.9f  %12.9f',dmin1,deltad,acc))
    if iloop == imin
        xp_tot=xp;
        yp_tot=yp;
        zp_tot=zp;
    else
        xp_tot=[xp_tot xp];
        yp_tot=[yp_tot yp];
        zp_tot=[zp_tot zp];
    end
    iloop=iloop+1;
end

%% finale

figure
plot3(xp_tot,yp_tot,zp_tot,'*')
%%%Proiezioni
grid on
zoom on
xlabel('f_0 [Hz]')
ylabel('spin-down [Hz/s]')
zlabel('Intensity of the maximum (plus the two nearests values)')
title('3-d plot, scanning values of spindown, around the true value')
% fn='figures/simulated_plot3_spindowns';
% print ('-depsc',fn)  %%%per l'eps
% print ('-djpeg',fn)  %%%per jpg
plot_triplets(xp_tot,yp_tot,zp_tot,'*')
xlabel('f_0 [Hz]')
ylabel('spin-down [Hz/s]')
title('Colour : intensity of the maximum')
plot_triplets(xp_tot,zp_tot,yp_tot,'*')
xlabel('f_0 [Hz]')
title('Colour : spin-down values[Hz/s]')
ylabel('Intensity of the maximum')
k0=find(zp_tot==max(zp_tot));
xp_tot(k0),yp_tot(k0),zp_tot(k0)
m=length(xp_tot)-1;
stepx=(max(xp_tot)-min(xp_tot))/m;
stepy=(max(yp_tot)-min(yp_tot))/m;
dx_tot=min(xp_tot):stepx:max(xp_tot);
dy_tot=min(yp_tot):stepy:max(yp_tot);
xx=xx(1:iii)-dmin;
yya=yya(1:iii);
yyf=yyf(1:iii);
yyd=yyd(1:iii);
figure, plot(xx,yyf),grid on
xlabel('Spin down d minus dmin  [Hz/s]')
ylabel('Frequency [Hz]')
title('Freq. of the signal vs (d minus dmin), on the found maxima')
figure, plot(xx,yyd),grid on
xlabel('Spin down (d minus dmin)  [Hz/s]')
ylabel('Spin down [Hz/s]')
title('d vs (d minus dmin), on the found maxima')
figure, plot(xx,yya),grid on
xlabel('Spin down (d minus dmin)  [Hz/s]')
ylabel('Intensity of the maxima')
title('Intensity vs (d minus dmin), on the found maxima')
mean(yya)

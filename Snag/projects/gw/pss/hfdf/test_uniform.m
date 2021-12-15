% test_uniform
%(res,edge,dmin,dmax,kdeltaf)
res=20;
edge=0;
dmin=0;
dmax=0;
kdeltaf=0;

format long
DTRUE=0.0050
lines(1).fr=50;
lines(1).d=DTRUE;
% lines(1).amp=10;
lines(1).amp=1000;
par.nt=500;
par.nfr=1000;
par.dt=1;
par.dfr=0.1;  %%0.1
% par.thresh=4;
par.thresh=40;
timfr_sim=crea_linpm(lines,par);
MAXLOOP=20 %10   %number of loops around the true spin-down
%%Set default values on the parameters, if needed
scale=2*10^6;  %%factor which multiplies deltad, when used...
if res == 0
    res=1.0;
end
if edge <= 0
    edge=0.00001;
end
if (dmin==0 && dmax==0)
    dmin=-10.5*DTRUE;
    dmax=10.5*DTRUE;
end
thr=0;
time=0;
%Read the time-frequency gd and creates two vectors and parameters
% AND 
%Set parameters, using the information read in the peakmap and given in noput
tim_tot=x_gd2(timfr_sim);
dfr=dx2_gd2(timfr_sim); %freq. step
ddays=dx_gd2(timfr_sim);  %time (days) step
t0=tim_tot(1);
tim_tot=(tim_tot-t0)*ddays;
A=y_gd2(timfr_sim); 
[ff,tt,aa]=find(A');
frini=ini_gd2(timfr_sim)
observation_time=max(tim_tot)+1;
tmax=observation_time
ff=(ff-1)*dfr;  %IMPORTANTE !! Per come funziona linpm
tt=tt*ddays;
n=n_gd2(timfr_sim);
nfr=m_gd2(timfr_sim);  %number of frequencies
nt=n/nfr;       %number of days       
a=frini; 
b=(nfr-1)*dfr;  %corretto 11/10/07 Era nfr-1
f0band=[a b]   %per prova attenzione !
f0band=[40 100]
factor=1;
if dmax < 0
    factor=0;
end
if kdeltaf==0
     kdeltaf=1;
end
frband(1)=f0band(1)*(1-edge)-factor*tmax*dmax;
if frband(1) < 0
    frband(1)=0
end
factor=1;
if dmin > 0
    factor=0;
end
frband(2)=f0band(2)*(1-edge)-factor*tmax*dmin;
if frband(2) > nfr*dfr            %%Attenzione: per ora viene sempre cosi', frband=f0band 
    frband(2)=nfr*dfr             %%11 ott 07 per come ho fatto su f0_band. Capire,cambiare
end
frband
f0_central=(f0band(2)-f0band(1))/2
%f0_res is the resolution for f0:
f0_res=dfr/res;
clear timfr_sim
%Deltad is the spin-down resolution. Depends on the observation time
% 2 ottobre 07: put to a value convenient for crea_linpm --simulation
deltad=2*DTRUE/40;
%%deltad= scale*dfr/(observation_time*86400)  %%uncomment for true analyses
%Deltaf is the bandwidth around freq on which to look to construct f0
deltaf= dfr*kdeltaf
%%%%%%%%%Evaluation of the number of bins and inizialization (=0)of the bin contents in the differential histogram%%%%%%%%%%%%%%%%
% nbin_f0=round(1+(f0band(2)-f0band(1))/f0_res);  %11 ott 07: direi
% sbagliato +1 e +2
% nbin_fr=round(1+(frband(2)-frband(1))/dfr);
% nbin_d=round(2+(dmax-dmin)/deltad)  %%direi 2 per prendere sia dmin che dmax. Verificare
nbin_f0=round((f0band(2)-f0band(1))/f0_res);
nbin_fr=round((frband(2)-frband(1))/dfr);
%Direct-Differentail histogram construction
%Differential (easier to be constructed)
tim_tot=tt-t0;
freq_tot=ff;
n_of_ff=length(ff);

% peaks(2,:)=ff;
% peaks(1,:)=tim_tot;

nloop=MAXLOOP;
imin=-round(nloop/2);
imax=-imin;
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

hmap.fr=[f0band(1) deltaf res nbin_f0];

dmin1=dmin+iloop*deltad/nloop;
hmap.d=[dmin1 deltad nbin_d];
peaks(1,1:par.nfr)=10;
peaks(2,1:par.nfr)=((0:par.nfr-1)*deltaf);

hdf0=hfdf_hough(hmap,peaks);


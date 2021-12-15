function [tfmap,vela,veld,vele]=crea_linpm_doppler(lines,par,antenna,timeini,ifig)
%CREA_LINPM  creates a linear frequncy peakmap
%
%  par           parameters structure
%     .nt        number of spectra
%     .nfr       number of frequencies
%     .dt        distance of every spectrum
%     .dfr       frequency resolution
%     .inifr     initial frequency
%     .thresh    threshold
%  lines(k)      line structures
%        .fr     frequency
%        .d      variation
%        .amp    amplitude
% ifig =1 does the figure

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

day2sec=86400.0;
coord=1;  %ecliptic
val=1;
if ~exist('ifig','var')
    ifig=0;
end
if ~exist('timeini','var')
    timeini=54247.0   %%mjd = 27/05/2007
end
if ~exist('antenna','var')
    %Virgo coordinates
    antenna.lat=43+37/60+53/3600; %deg
    antenna.long=10+30/60+16/3600; %deg
end
if ~exist('lines','var')
    lines(1).fr=10;
    lines(1).d=0;
    lines(1).amp=3*val;
    lines(1).lat=0;  %%eclittica
    lines(1).long=0;
    lines(2).fr=30;
    lines(2).d=0.005;
    lines(2).lat=0;
    lines(2).long=0;
    lines(2).amp=4*val;
    lines(3).fr=90;
    lines(3).d=-0.01;
    lines(3).amp=5*val;
    lines(3).lat=0;
    lines(3).long=0;
end

if ~exist('par')
    par.nt=500;
    par.nfr=1000;
    par.dt=1;
    par.dfr=0.1;
    par.inifr=0;
    par.thresh=4*val;
end

nlin=length(lines);
nspect=par.nt;
nfr=par.nfr;
dfr=par.dfr;


A=zeros(par.nt,par.nfr);
npeaktot=0; %disp('ciao'), nlin,lines(1).d*par.dt
for k = 1:nlin
	ss(1)=lines.long;  
	ss(2)=lines.lat;
	ss(3)=1;
	s(:,k)=astro2rect(ss,0);  %0 for degrees
end
r(1)=antenna.long;
r(2)=antenna.lat;
vela=zeros(nspect);
veld=zeros(nspect);
vele=zeros(nspect);
for i = 1:nspect
   y=(randn(1,nfr).^2+randn(1,nfr).^2)/2;
   timeday=timeini+par.dt*(i-1)/day2sec; %days
   timesec=par.dt*(i-i); %seconds from beginning time
    [va,vd,ve]=earth_v1(timeday,antenna.long,antenna.lat,coord);
    rr(1)=va;
    rr(2)=vd;
    rr(3)=ve;
    vela(i)=va;
    veld(i)=vd;
    vele(i)=ve;
    det_r=astro2rect(rr,1);  %1 for radians in input
   for j = 1:nlin        
       f0=((lines(j).fr)+lines(j).d*timesec);
       scalarp=det_r(1)*s(1,j)+det_r(2)*s(2,j)+det_r(3)*s(3,j);
       fdoppl=f0*(1+scalarp)-par.inifr;
       ind=round(fdoppl/dfr+1);
       if ind < 1
           ind=1;
       end
       y(ind)=((randn(1,1)+sqrt(2*lines(j).amp)).^2+randn(1,1).^2)/2;
   end
   y1=rota(y,1);
   y2=rota(y,-1);
   y1=ceil(sign(y-y1)/2);
   y2=ceil(sign(y-y2)/2+0.1);
   y1=y1.*y2;
   y=y.*y1;
   y2=ceil(sign(y-par.thresh)/2);
   y=y.*y2;
   npeak=sum(y2);
   [i1,j1,s1]=find(y);
   i2(npeaktot+1:npeaktot+npeak)=j1;
   j2(npeaktot+1:npeaktot+npeak)=i;
   s2(npeaktot+1:npeaktot+npeak)=s1;
   npeaktot=npeaktot+npeak;
end

p.tfmap.npeaktot=npeaktot; npeaktot; %,figure,plot(i2,j2,'.')

A=sparse(i2,j2,s2,nfr,nspect);
if ifig ==1
    figure;
    spy(A);
end

tfmap=gd2(A');
dx=par.dt;
dx2=par.dfr;ini2=0;
capt='line defaced peakmap';
ini2=par.inifr;
tfmap=edit_gd2(tfmap,'dx',dx,'dx2',dx2,'ini2',ini2,'capt',capt);

coord=1;  %%for ecliptic coord.
%%%%%%%%%tfmap=set_gd2_v();
%Output vel are in degrees. Need to be converted !
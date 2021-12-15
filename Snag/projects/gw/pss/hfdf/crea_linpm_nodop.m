function [tfmap peaks]=crea_linpm_nodop(lines,par,timeini,adapt,ifig)
%CREA_LINPM  creates a linear frequncy peakmap
%
%  par           parameters structure
%     .nt        number of spectra
%     .nfr       number of frequencies
%     .dt        distance of every spectrum
%     .dfr       frequency resolution
%     .inifr     initial frequency
%  lines(k)      line structures
%        .fr     frequency
%        .d      variation
%        .amp    amplitude
% thresh         threshold
% adapt.ic       adaptive (0, 1 or -1 -> to gd_smooth)
%      .tau      tau (samples; def 8)
%      .typ      1 rectangular, 0 exponential (def)
%       or double that means adapt.ic
% ifig =1 does the figure
%
% tfmap   peakmap (gd2 spars matrix)
% peaks   peakmap as a (2,n) matrix

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

day2sec=86400.0;
val=1;
if ~exist('ifig','var')
    ifig=0;
end
if ~exist('adapt','var')
    adapt.ic=0;
    adapt.tau=8;
    adapt.typ=0;
end
if isnumeric(adapt)
    adapt.ic=adapt;
    adapt.tau=8;
    adapt.typ=1;
end
if ~exist('timeini','var')
    timeini=54247.0   %%mjd = 27/05/2007
end
if ~exist('lines','var')
    lines(1).fr=10;
    lines(1).d=0;
    lines(1).amp=3*val;
    lines(2).fr=30;
    lines(2).d=0.005;
    lines(2).amp=4*val;
    lines(3).fr=90;
    lines(3).d=-0.01;
    lines(3).amp=5*val;
end

if ~exist('par','var')
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
peaks=[];

ladapt=adapt.tau;
mar=ladapt*abs(adapt.ic)*3;
nfr1=nfr+2*mar;
ymean=zeros(1,nspect);
gmean=zeros(1,nspect);

A=zeros(nspect,nfr);
npeaktot=0; 
%figure
for i = 1:nspect
   y=(randn(1,nfr1).^2+randn(1,nfr1).^2)/2;
   timesec=timeini*day2sec+par.dt*(i-1); 
   for j = 1:nlin        
       f0=lines(j).fr+lines(j).d*timesec;
       ff=f0-par.inifr;
       ind=round(ff/dfr+1)+mar;
       if ind < 1
           ind=1;
       end
       y(ind)=((randn(1,1)+sqrt(2*lines(j).amp)).^2+randn(1,1).^2)/2;
   end
   if adapt.ic ~= 0
       g=gd_smooth(y,ladapt,adapt.ic,adapt.typ);
       y=y./g;
       gmean(i)=mean(g(mar+1:nfr1-mar));
   end
   ymean(i)=mean(y(mar+1:nfr1-mar));
   y=y/ymean(i);
   y1=rota(y,1);
   y2=rota(y,-1);
   y1=ceil(sign(y-y1)/2);
   y2=ceil(sign(y-y2)/2+0.1);
   y1=y1.*y2;
   y=y.*y1;
   y2=ceil(sign(y-par.thresh)/2);
   y=y.*y2;
   y=y(mar+1:nfr1-mar);
   y2=y2(mar+1:nfr1-mar);
   npeak=sum(y2);
   [i1,j1,s1]=find(y);
   i2(npeaktot+1:npeaktot+npeak)=j1;
   j2(npeaktot+1:npeaktot+npeak)=i;
   s2(npeaktot+1:npeaktot+npeak)=s1;
   npeaktot=npeaktot+npeak;
%    disp(sprintf('%d maean %f  n %d',i,ymean,npeak))
end

% figure,plot(ymean),hold on,grid on,plot(gmean,'r')

p.tfmap.npeaktot=npeaktot; npeaktot %,figure,plot(i2,j2,'.')

A=sparse(i2,j2,s2,nfr,nspect);
if ifig ==1
    figure;
    spy(A);
end

tfmap=gd2(A');
dx=par.dt;
dx2=par.dfr;
capt='line defaced peakmap';
ini2=par.inifr;
tfmap=edit_gd2(tfmap,'dx',dx,'dx2',dx2,'ini2',ini2,'capt',capt);
peaks(1,:)=(j2-1)*dx;
peaks(2,:)=(i2-1)*dx2+ini2;
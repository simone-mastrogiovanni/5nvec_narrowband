function tfmap=crea_linpm(lines,par)
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

% Version 2.0 - January 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

val=1;

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

for i = 1:nspect
   y=(randn(1,nfr).^2+randn(1,nfr).^2)/2;
   for j = 1:nlin
       ind=round(((lines(j).fr-par.inifr)+lines(j).d*par.dt*(i-1))/dfr+1);
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

p.tfmap.npeaktot=npeaktot; npeaktot%,figure,plot(i2,j2,'.')

A=sparse(i2,j2,s2,nfr,nspect);
figure;
spy(A);

tfmap=gd2(A');
dx=par.dt;
dx2=par.dfr;ini2=0;
capt='line defaced peakmap';
ini2=par.inifr;
tfmap=edit_gd2(tfmap,'dx',dx,'dx2',dx2,'ini2',ini2,'capt',capt);

tfmap=set_gd2_v(tfmap,0,0,0);
% driver_hfdf_full

%  par           parameters structure
%     .nt        number of spectra
%     .dt        distance of every spectrum (s)
%     .dfr       frequency resolution
%     .inifr     initial frequency
%     .finfr
%     .thresh    threshold

%  lines(k)      line structures
%        .fr     frequency
%        .d      variation
%        .amp    amplitude

%    hmap           hough map structure
%        .fr        [minf df enh maxf] min fr, enhanced frequency step, maxfr
%        .d         [mind dd nd] min d, step, number of d
%    peaks(2,n)     peaks of the peakmap as [t,fr] 
%    factdop(nt)    Doppler correction factor (if present) 

%    refine.dw      how many d samples for side (norm 1)
%    refine.denh    d enhancement factor (norm 10)
%    refine.frw     how many f0 samples for side (norm 3)
%    refine.frenh   f0 enhancement factor (norm 20)

par.nt=3000;
par.dt=1000;
par.dfr=0.01;
par.nfr=100;
par.inifr=100;
par.finfr=101;
par.thresh=2.5;

d_samp=1.e-9;
nd_samp=400;
enhfact=10;

frx=100.7;
dx=-1e-7;
% dx=0;
lines(1).fr=frx+par.dfr*(rand(1,1)-0.5);
lines(1).d=dx+d_samp*(rand(1,1)-0.5);
lines(1).amp=2;
lines(1).long=0;
lines(1).lat=44;

refine.dw=10;
refine.denh=10;
refine.frw=3;
refine.frenh=20;

doperr=1 ; % Doppler error: 0 or 1

%------------------------------

[tfmap peaks]=crea_linpm_nodop(lines,par,0,-1,0); 

x=peaks(1,:);
np=length(x);
ix=[0 find(diff(x)) np];

y=peaks(2,:);
for i = 1:length(ix)-1
    y(ix(i)+1:ix(i+1))=y(ix(i)+1:ix(i+1))+doperr*(rand(1,1)-0.5)*par.dfr;
end
peaks(2,:)=y;
figure,plot(x,y,'.'),grid on,xlabel('t'),ylabel('f'),ylim([min(y) max(y)]),title('PeakMap')

hmap.fr=[par.dfr enhfact];
hmap.d=[-2.e-7 d_samp nd_samp];

[hdf0 hmap0]=hfdf_hough(hmap,peaks);

disp(sprintf('f0 = %f  det.f0 = %f  err = %f',lines(1).fr,hmap0.top.f,hmap0.top.f-lines(1).fr))
disp(sprintf(' d = %e  det.e  = %f  err = %e',lines(1).d,hmap0.top.d,hmap0.top.d-lines(1).d))

rin=round((lines(1).d-hmap0.d(1))/hmap0.d(2))+1;
inf0=gd2_to_gd(hdf0,1,0,rin);
figure,plot(inf0),hold on,plot(inf0,'r.'),title('Frequency section - full'),xlabel('f_0')

rin=round((lines(1).fr-hmap0.fr(1))/(hmap0.fr(2)/hmap0.fr(3)))+1;
ind0=gd2_to_gd(hdf0,2,rin,0);
figure,plot(ind0),hold on,plot(ind0,'r.'),title('Spin-down section - full'),xlabel('d')

reffrin=frx-refine.frw*par.dfr;
reffrfi=frx+refine.frw*par.dfr;
hmap.fr=[reffrin par.dfr refine.frenh reffrfi];
refdin=dx-refine.dw*d_samp;
hmap.d=[refdin d_samp/refine.denh refine.denh*refine.dw*2];

[hdf1 hmap1]=hfdf_hough(hmap,peaks,1);

disp(sprintf('f0 = %f  det.f0 = %f  err = %f',lines(1).fr,hmap1.top.f,hmap1.top.f-lines(1).fr))
disp(sprintf(' d = %e  det.d  = %e  err = %e',lines(1).d,hmap1.top.d,hmap1.top.d-lines(1).d))

rin=round((lines(1).d-hmap1.d(1))/hmap1.d(2))+1;
inf1=gd2_to_gd(hdf1,1,0,rin);
figure,plot(inf1),hold on,plot(inf1,'r.'),title('Frequency section - sel'),xlabel('f_0')

rin=round((lines(1).fr-hmap1.fr(1))/(hmap1.fr(2)/hmap1.fr(3)))+1;
ind1=gd2_to_gd(hdf1,2,rin,0);
figure,plot(ind1),hold on,plot(ind1,'r.'),title('Spin-down section - sel'),xlabel('d')

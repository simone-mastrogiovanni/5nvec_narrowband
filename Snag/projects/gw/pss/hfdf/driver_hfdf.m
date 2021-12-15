% driver_hfdf

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
% ifig =1 does the figure

%    hmap           hough map structure
%        .fr        [minf df enh maxf] min fr, enhanced frequency step, maxfr
%        .d         [mind dd nd] min d, step, number of d
%    peaks(2,n)     peaks of the peakmap as [t,fr] 
%    factdop(nt)    Doppler correction factor (if present)   

par.nt=2000;
par.dt=1000;
par.dfr=0.01;
par.nfr=100;
par.inifr=100;
par.finfr=101;
par.thresh=3;

lines(1).fr=100.7;
lines(1).d=-1e-7;
% lines(1).d=0;
lines(1).amp=2;
lines(1).long=0;
lines(1).lat=44;

enhfact=10;
hmap.fr=[par.inifr par.dfr enhfact par.finfr];
hmap.fr=[par.dfr enhfact];
hmap.d=[-2.e-7 1.e-9 400];

% hmap.fr=[100.65 par.dfr enhfact 100.75];
% hmap.d=[-1.1e-7 1.e-9/5 20*5];

[tfmap peaks]=crea_linpm_nodop(lines,par,0,0);

x=peaks(1,:);
y=peaks(2,:);
% figure,plot(x,y,'.'),grid on

% hdf0=hfdf_hough2010Carl(1,hmap,peaks);
[hdf0 hmap0]=hfdf_hough(hmap,peaks,3);

rin=round((lines(1).d-hmap0.d(1))/hmap0.d(2))+1;
inf0=gd2_to_gd(hdf0,1,0,rin);
figure,plot(inf0),hold on,plot(inf0,'r.')

rin=round((lines(1).fr-hmap0.fr(1))/(hmap0.fr(2)/hmap0.fr(3)))+1;
ind=gd2_to_gd(hdf0,2,rin,0);
figure,plot(ind),hold on,plot(ind,'r.')

% rout=round((1e-7-hmap.d(1))/hmap.d(2))+1;
% out=gd2_to_gd(hdf0,1,0,rout)
% figure,plot(out),hold on,plot(out,'r.')
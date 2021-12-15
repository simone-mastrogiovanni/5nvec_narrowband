% driver_hfdf

%  par           parameters structure
%     .nt        number of spectra
%     .nfr       number of frequencies
%     .dt        distance of every spectrum (s)
%     .dfr       frequency resolution
%     .inifr     initial frequency
%     .thresh    threshold
%  lines(k)      line structures
%        .fr     frequency
%        .d      variation
%        .amp    amplitude
% ifig =1 does the figure

%    hmap           hough map structure
%        .fr        [minf df enh nf] min fr, original step, enhancement
%                   factor, number of fr
%        .d         [mind dd nd] min d, step, number of d
%    peaks(2,n)     peaks of the peakmap as [t,fr] 
%    factdop(nt)    Doppler correction factor (if present)   

par.nt=2000;
par.nfr=100;
par.dt=1000;
par.dfr=0.01;
par.inifr=100;
par.thresh=3;

lines(1).fr=100.7;
lines(1).d=-1e-7;
lines(1).d=0;
lines(1).amp=2;
lines(1).long=0;
lines(1).lat=44;

hmap.fr=[par.inifr par.dfr 10 par.nfr];
hmap.d=[-2.e-7 1.e-9 400];

[tfmap peaks]=crea_linpm_nodop(lines,par,0,0);

x=peaks(1,:);
y=peaks(2,:);
figure,plot(x,y,'.'),grid on

% hdf0=hfdf_hough2010Carl(1,hmap,peaks);
[hdf0 hmap]=hfdf_hough00(hmap,peaks);

rin=round((lines(1).d-hmap.d(1))/hmap.d(2))+1;
in=gd2_to_gd(hdf0,1,0,rin)
figure,plot(in),hold on,plot(in,'r.')

rout=round((1e-7-hmap.d(1))/hmap.d(2))+1;
out=gd2_to_gd(hdf0,1,0,rout)
figure,plot(out),hold on,plot(out,'r.')
% driver_hfdf_multi

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

N=50   % number of iterations
errf0=zeros(1,N);
errd=errf0;
errf01=errf0;
errd1=errd;

par.nt=2000;
par.dt=1000;
par.dfr=0.01;
par.nfr=100;
par.inifr=100;
par.finfr=101;
par.thresh=3;

refine.dw=10;
refine.denh=10;
refine.frw=3;
refine.frenh=20;

d_samp=1.e-9;
nd_samp=400;
d_samp=5.e-9;
nd_samp=80;
enhfact=10;

frx=100.7;
dx=-1e-7;

doperr=1 ; % Doppler error: 0 or 1

for i = 1:N
    disp(i)
    lines(1).fr=frx+par.dfr*(rand(1,1)-0.5);
    lines(1).d=dx+d_samp*(rand(1,1)-0.5);
    % lines(1).d=0;
    lines(1).amp=2;
    lines(1).long=0;
    lines(1).lat=44;

    %------------------------------

    [tfmap peaks]=crea_linpm_nodop(lines,par,0,0);

    x=peaks(1,:);
    np=length(x);
    ix=[0 find(diff(x)) np];

    y=peaks(2,:);
    for j = 1:length(ix)-1
        jj=ix(j)+1:ix(j+1);
        y(jj)=y(jj)+doperr*(rand(1,1)-0.5)*par.dfr;
    end
    peaks(2,:)=y;

    hmap.fr=[par.dfr enhfact];
    hmap.d=[-2.e-7 d_samp nd_samp];

    [hdf0 hmap0]=hfdf_hough(hmap,peaks,0,0);
    
    errf0(i)=hmap0.top.f-lines(1).fr;
    errd(i)=hmap0.top.d-lines(1).d;

    reffrin=frx-refine.frw*par.dfr;
    reffrfi=frx+refine.frw*par.dfr;
    hmap.fr=[reffrin par.dfr refine.frenh reffrfi];
    refdin=dx-refine.dw*d_samp;
    hmap.d=[refdin d_samp/refine.denh refine.denh*refine.dw*2];

    [hdf1 hmap1]=hfdf_hough(hmap,peaks,1,0);
    errf01(i)=hmap1.top.f-lines(1).fr;
    errd1(i)=hmap1.top.d-lines(1).d;
end

figure,plot(errf0,'.'),hold on,plot(errf01,'r.'),grid on,title('frequency error')
figure,plot(errd,'.'),hold on,plot(errd1,'r.'),grid on,title('spindown error')

disp(sprintf('Frequency error before: %f ± %f',mean(errf0),std(errf0)))
disp(sprintf('                 after: %f ± %f',mean(errf01),std(errf01)))

disp(sprintf('Spindown error before: %e ± %e',mean(errd),std(errd)))
disp(sprintf('                after: %e ± %e',mean(errd1),std(errd1)))

figure,hist(errf0),title('Frequency before')
figure,hist(errf01),title('Frequency after')
figure,hist(errd),title('Spindown before')
figure,hist(errd1),title('Spindown after')
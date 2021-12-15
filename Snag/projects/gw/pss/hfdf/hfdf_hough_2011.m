function [hdf0 hmap0]=hfdf_hough(hmap,peaks,invhough,verb)
%HFDF_HOUGH  creates a f/df Hough map
%
%     [hdf0 hmap0]=hfdf_hough(hmap,peaks,invhough)
%
% 2 modes: full map (explorative): takes into account all the peaks
%          sel map (refinement): select only peaks of interest, with two flavours:
%                      - full band
%                      - inv Hough
%
%    hmap            hough map structure
%        .fr         sel  mode : [minf df enh maxf] min fr, enhanced frequency step, maxfr
%                    full mode : [df enh]
%        .d          [mind dd nd] min d, step, number of d
%        .top
%            .n      max number of tops
%            .nsd    number of sigma
%            .f,d,z  tops (output)
%    peaks(2,n)      peaks of the peakmap as [t,fr] (corrected for the Doppler effect)
%    invhough        0 no inv Hough, k inverse hough band of amp k
%    verb            verbosity (def 1)

% Version 2.0 - April 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

if ~exist('invhough','var')
    invhough=0;
end

if ~exist('verb','var')
    verb=1;
end

if ~exist('hmap.top','var')
    hmap.top.n=1;
    hmap.top.nsd=1;
end

[t,f,mimaf,mimaf0]=nat_range(peaks,hmap.d);

npeaks=length(t);

if verb > 0
    disp(sprintf('%d peaks in the range of %f <-> %f Hz',npeaks,mimaf(1),mimaf(2)));
end

mind1=hmap.d(1);
maxd1=mind1+hmap.d(2)*(hmap.d(3)-1);

if length(hmap.fr) == 2
    tit='full';
    hmap.fr(4)=mimaf0(2);
    hmap.fr(3)=hmap.fr(2);
    hmap.fr(2)=hmap.fr(1);
    hmap.fr(1)=mimaf0(1);
    minf0=hmap.fr(1);
    maxf0=hmap.fr(4);
else
    % sel peaks
    tit='sel';
    minf0=hmap.fr(1);
    maxf0=hmap.fr(4);
    df=hmap.fr(2);
    
    Df1=mind1*t;
    Df2=maxd1*t;

    if invhough == 0
        f_1=minf0+min(min(Df1,Df2));
        f_2=maxf0+max(max(Df1,Df2));
    else
        % inverse Hough

        f_1=minf0+min(Df1,Df2)+invhough*df;
        f_2=maxf0+max(Df1,Df2)-invhough*df;
    end
    
    iii=find(f > f_1 & f < f_2);
    npeaksbef=length(f);
    npeaksaft=length(iii);
    peaks=peaks(:,iii); 

    [t1,f1,mimaf,mimaf0]=nat_range(peaks,hmap.d);
    minf0=mimaf0(1);
    maxf0=mimaf0(2);
    
    if verb > 0
        figure,plot(t,f,'.'),hold on,plot(t(iii),f(iii),'r.'),ylim([min(f) max(f)])
        title('Inverse Hough'),xlabel('t'),ylabel('f')
        disp(sprintf('Requested frequencies %f <-> %f  for %d peaks selected',hmap.fr(1),hmap.fr(4),npeaksaft))
        disp(sprintf('  recomputed range %f <-> %f',minf0,maxf0))
    end
end

df=hmap.fr(2);
enh=hmap.fr(3);
df2=df/2;
ddf=df/enh;
inifr=minf0-df2-ddf;
finfr=maxf0+df2+ddf;
nbin_f0=ceil((finfr-inifr)/ddf)+2;
deltaf2=round(enh/2+0.001);

n_of_ff=length(peaks);
ii=find(diff(peaks(1,:)));
ii=[ii n_of_ff]; 
nt=length(ii);

dmin1=hmap.d(1); 
deltad=hmap.d(2);
nbin_d=hmap.d(3);
id=1:nbin_d; 

ii0=1;

binh_df0=zeros(nbin_d,nbin_f0);size(binh_df0)

for it = 1:nt
    kf=(peaks(2,ii0:ii(it))-inifr)/ddf;
    t=peaks(1,ii0);
    ii0=ii(it)+1;
    f0_a=kf-deltaf2;
    
    for id = 1:nbin_d
        d=dmin1+(id-1)*deltad;
        td=d*t/ddf;
        a=1+round(f0_a-td);
        binh_df0(id,a)=binh_df0(id,a)+1;
    end
end

binh_df0(:,deltaf2*2+1:nbin_f0)=...
    binh_df0(:,deltaf2*2+1:nbin_f0)-binh_df0(:,1:nbin_f0-deltaf2*2); % by Carl Sabottke
binh_df0=cumsum(binh_df0,2);
    
hdf0=gd2(binh_df0.');
hdf0=edit_gd2(hdf0,'dx',ddf,'ini',inifr,'dx2',deltad,'ini2',dmin1,'capt','Histogram of spin-f0');

mu=mean(binh_df0(:));
sd=std(binh_df0(:));
thresh=hmap.top.nsd*sd+mu;
res=hmap.fr(3);
[hmap.top.f,hmap.top.d,hmap.top.z]=twod_peaks(hdf0,thresh,hmap.top.n,res);

if verb > 0
    image_gd2(hdf0);title(['Hough map ' tit]),xlabel('f_9'),ylabel('d')
end

hmap0=hmap;
hmap0.fr(1)=inifr;
hmap0.fr(4)=finfr;


function [t,f,mimaf,mimaf0]=nat_range(peaks,dvec)

mind1=dvec(1);
maxd1=mind1+dvec(2)*(dvec(3)-1);

t=peaks(1,:);
f=peaks(2,:);

mint1=min(t);
maxt1=max(t);

minf1=min(f);
maxf1=max(f);
mimaf=[minf1 maxf1];

DTmax=max([mint1*mind1 mint1*maxd1 maxt1*mind1 maxt1*maxd1]);
DTmin=min([mint1*mind1 mint1*maxd1 maxt1*mind1 maxt1*maxd1]);

minf0=minf1-DTmax;
maxf0=maxf1-DTmin;

mimaf0=[minf0 maxf0];

function [hdf0 hmap]=hfdf_hough(hmap,peaks,factdop)
%HFDF_HOUGH  creates a linear peakmap
%
%    hmap           hough map structure
%        .fr        [minf df enh nf] min fr, original step, enhancement
%                   factor, number of fr
%        .d         [mind dd nd] min d, step, number of d
%    peaks(2,n)     peaks of the peakmap as [t,fr] 
%    factdop(nt)    Doppler correction factor (if present)   

inifr=hmap.fr(1);
deltaf=hmap.fr(2);
ddf=deltaf/hmap.fr(3);
nbin_f0=ceil(hmap.fr(4)*hmap.fr(3));
dmin1=hmap.d(1); %?
deltad=hmap.d(2);
nbin_d=hmap.d(3); %?
n_of_ff=length(peaks); %?
ii=find(diff(peaks(1,:)));
ii=[ii n_of_ff]; 
nt=length(ii); 

if ~exist('factdop','var')
    factdop=ones(1,nt);
end

ii0=1;

id=1:nbin_d;
maxt=peaks(1,n_of_ff)
mind=min(dmin1+(id-1)*deltad)
maxd=max(dmin1+(id-1)*deltad)
deltaf2=(deltaf/2)/ddf
miny=floor((min(peaks(2,:))*0.9999-inifr+mind*maxt)/ddf-deltaf2)
maxy=ceil((max(peaks(2,:))*1.0001-inifr+maxd*maxt)/ddf+deltaf2)
if miny > 0
    miny=0;
end
if maxy < nbin_f0
    maxy=nbin_f0;
end

nbin_f0=maxy-miny+100;
inifr=inifr+miny*ddf

binh_df0=zeros(nbin_d,nbin_f0);size(binh_df0) %?

for it = 1:nt
    y=(peaks(2,ii0:ii(it))*factdop(it)-inifr)/ddf;
%     t=peaks(1,ii0)/ddf; %??
    t=peaks(1,ii0);
    ii0=ii(it)+1;
    f0_a=y-deltaf2;
    f0_b=y+deltaf2;
    
    for id = 1:nbin_d
        d=dmin1+(id-1)*deltad;
        td=d*t/ddf;
        a=1+round(f0_a-td);
        b=1+round(f0_b-td);%a,b
        binh_df0(id,a)=binh_df0(id,a)+1;
        binh_df0(id,b)=binh_df0(id,b)-1;
    end
end

binh_df0=cumsum(binh_df0,2);
    
hdf0=gd2(binh_df0.'); 
hdf0=edit_gd2(hdf0,'dx',ddf,'ini',inifr,'dx2',deltad,'ini2',dmin1,'capt','Histogram of spin-f0');

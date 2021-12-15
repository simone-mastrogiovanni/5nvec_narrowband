function hdf0=hfdf_hough(hmap,peaks)
%HFDF_HOUGH  creates a linear peakmap
%
%    hmap           hough map structure
%        .fr        [minf df enh nf] min fr, original step, enhancement
%                   factor, number of fr
%        .d         [mind dd nd] min d, step, number of d
%    peaks(2,n)     peaks of the peakmap as [t,fr] 
% 

inifr=hmap.fr(1);
deltaf=hmap.fr(2);
ddf=deltaf/hmap.fr(3);
nbin_f0=hmap.fr(4);
dmin1=hmap.d(1);
deltad=hmap.d(2);
nbin_d=hmap.d(3);
n_of_ff=length(peaks);
ii=find(diff(peaks(1,:)));
ii=[ii n_of_ff];
nt=length(ii);
ii0=1;
deltaf2=(deltaf/2)/ddf;

binh_df0=zeros(nbin_d,nbin_f0);

for it = 1:nt
    y=(peaks(2,ii0:ii(it))-inifr)/ddf;
    t=peaks(1,ii0)/ddf;
    ii0=ii(it)+1;
    f0_a=y-deltaf2;
    f0_b=y+deltaf2;
    
    for id = 1:nbin_d
        d=dmin1+(id-1)*deltad;
        td=d*t;
        a=1+round(f0_a-td);
        b=1+round(f0_b-td);
        binh_df0(id,a)=binh_df0(id,a)+1;
        binh_df0(id,b)=binh_df0(id,b)-1;
    end
end

binh_df0=cumsum(binh_df0,2);
    
hdf0=gd2(binh_df0.'); 
hdf0=edit_gd2(hdf0,'dx',ddf,'ini',inifr,'dx2',deltad,'ini2',dmin1,'capt','Histogram of spin-f0');

function hdf0=hfdf_hough(hmap,peaks)
%HFDF_HOUGH  creates a linear peakmap
%
%    hmap           hough map structure
%        .fr        [minf df enh nf] min fr, original step, enhancement
%                   factor, number of fr
%        .d         [mind dd nd] min d, step, number of d
%    peaks(2,n)     peaks of the peakmap as [t,fr] 
% 

%old:(f0band,f0_res,nbin_d,nbin_f0,dmax0,dmin1,deltad,deltaf,freq_tot,tim_t
%ot,n_of_ff)

inifr=hmap.fr(1);
deltaf=hmap.fr(2);
ddf=deltaf/hmap.fr(3);
nbin_f0=hmap.fr(4);
dmin1=hmap.d(1);
deltad=hmap.d(2);
nbin_d=hmap.d(3);
n_of_ff=length(peaks);

binh_df0=zeros(nbin_d,nbin_f0);  %%matrix for both spin-down and f_0

for id = 1:nbin_d
    bin_df0=zeros(1,nbin_f0);
    d=dmin1+(id-1)*deltad;

    f0_a=peaks(2,:)-(deltaf/2)-d*peaks(1,:);
    f0_b=peaks(2,:)+(deltaf/2)-d*peaks(1,:);
    a=1+round((f0_a-inifr)/ddf);
    b=1+round((f0_b-inifr)/ddf);
    [ii,jj]=find(a<1);a(ii,jj)=1;
    [ii,jj]=find(a>nbin_f0);a(ii,jj)=nbin_f0;
    [ii,jj]=find(b<1);b(ii,jj)=1;
    [ii,jj]=find(b>nbin_f0);b(ii,jj)=nbin_f0;
    for i = 1:n_of_ff
        ia=a(i);
        ib=b(i);
        bin_df0(ia)=bin_df0(ia)+1;
        bin_df0(ib)=bin_df0(ib)-1;
    end
    binh_df0(id,:)=cumsum(bin_df0);
end
    
% IMPORTANT: Integral histogram of the matrix bin_df0: sum over the f0
% bins, for each spin-down (d) value
 
%Construct a gd type 2 with the integral histogram
%IMPORTANT hdf0: Construct a gd2 for the integral matrix, with d on the y
hdf0=gd2(binh_df0'); %%to have, in the map the spin-down on y and f0 on x
hdf0=edit_gd2(hdf0,'dx',ddf,'ini',inifr,'dx2',deltad,'ini2',dmin1,'capt','Histogram of spin-f0');

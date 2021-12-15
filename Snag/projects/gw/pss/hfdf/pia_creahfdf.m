function [hdf0,dfr,lfft,len,frband]=pia_creahfdf(f0band,res,edge,dmin,dmax,tmax,kdeltaf)
%PIA_creahfdf from a vbl-file peakmap creates, using pia_creatimfr, a hough
%tranformation to the plane (f0,fdot)
%
% In a vbl-file the first channel is the parameters, the second the bins,
% the third the amplitudes; other channels can contain short spectra and
% other.
%
%   f0band =0  --> [100 200]  %100 200 per prova Bandwidth to be analyzed on f0
%   res  =0  -->1
%   edge   <=0  -->0.00001
%   dmin,dmax  min,max spindown values. Hz/s; =0  0--> dmin=-0.1  dmax=0.1
%   ATTENZIONE: 0,0 default su d va bene solo ora per le mie prove. Dovremo
%   fare diversamente !!!  Sergio e' d'accordo ! 24/08/07
%   tmax = maximum allowed observetion time, in days  0 --> 2 days
% kdeltaf = factor to get, from dfr, the deltaf bandwith over which to look for f0
% =0 -->1 used for instrumental disturbances
%
%
%   timfr         output (a gd2 , with time (x) and frequencies (y))
%   dfr            frequency resolutin, Hz
%   lfft           length of each FFT
%   len            FFTs total number
%   hdf0           output (a gd2 , with f0 and fdot )
% Version xx - 13 September 2007
% by Pia
% E.g. 
%      [hdf0,dfr,lfft,len,frband]=pia_creahfdf(0,1,0,0,0,0,0);
%% forse timfr posso rimetterlo
cd c:\matlab\hough-pia
scale=100000  %%factor which multiplies deltad
%%Set default values on the parameters, if needed
if f0band==0
    f0band=[40 50]   %per prova attenzione !
end
f0_central=(f0band(2)-f0band(1))/2
if res == 0
    res=1.0;
end
if edge <= 0
    edge=0.00001;
end
if (dmin==0 && dmax==0)
    dmin=-0.1
    dmax=0.1;
end
if tmax == 0
    tmax=2
end
factor=1;
if dmax < 0
    factor=0;
end
if kdeltaf==0
    kdeltaf=1;
end
frband(1)=f0band(1)*(1-edge)-factor*tmax*dmax;
factor=1;
if dmin > 0
    factor=0;
end
frband(2)=f0band(2)*(1-edge)-factor*tmax*dmin;
frband
thr=0;
time=0;
%%%Read the vbl peakmap file and extract a time-frequency gd
[timfr,dfr,lfft,len]=pia_creatimfr(frband,thr,time);
%%Set parameters, using the information read in the peakmap and given in noput
t0=x_gd(timfr(1))
frini=y_gd(timfr(1))
tim_tot=x_gd(timfr)-t0;
freq_tot=y_gd(timfr);
observation_time=max(x_gd(timfr))-min(x_gd(timfr))
%f0_res is the resolution for f0:
f0_res=dfr/res;
%Deltad is the spin-down resolution. Depends on the observation time
%%deltad= scale*dfr/(observation_time*86400)
deltad=(dmax-dmin)/200
%Deltaf is the bandwidth around freq on which to look to construct f0
deltaf= dfr*kdeltaf
%%%%%%%%%Evaluation of the number of bins and inizialization (=0)of the bin contents in the differential histogram%%%%%%%%%%%%%%%%
nbin_f0=round(1+(f0band(2)-f0band(1))/f0_res)
nbin_fr=round(1+(frband(2)-frband(1))/dfr)
nbin_d=round(2+(dmax-dmin)/deltad)  %%direi 2 per prendere sia dmin che dmax. Verificare
bin_f0(1:round(nbin_f0))=0;
bin_df0(round(nbin_d),round(nbin_f0))=0;  %%matrix for both spin-down and f_0
%%Direct-Differentail histogram construction
%Differential (easier to be constructed)
ispin=0;
n=size(freq_tot);
d=dmin;
while d <= dmax
    d=dmin+ispin*deltad
    ispin=ispin+1;
    for i=1:n(1)
        f0_a=freq_tot(i)-(deltaf/2)-d*tim_tot(i);
        f0_b=freq_tot(i)+(deltaf/2)-d*tim_tot(i);
        a=1+round((f0_a-f0band(1))/f0_res);
        b=1+round((f0_b-f0band(1))/f0_res);
        c=ispin;
        if a < 1
            a=1;
        end
        if  a > nbin_f0
            a=nbin_f0;
        end
        if b < 1
            b=1;
        end
        if  b > nbin_f0
            b=nbin_f0;
        end           
        bin_f0(a)=bin_f0(a)+1; 
        bin_f0(b)=bin_f0(b)-1;
        bin_df0(c,a)=bin_df0(c,a)+1;
        bin_df0(c,b)=bin_df0(c,b)-1;
    end   
end
%% bin_df0(:,1) e.g. to see ...
%Construct a gd type 2 with the differential histogram
hfdf=gd(bin_f0);
hfdf=edit_gd(hfdf,'dx',f0_res,'ini',f0band(1),'capt','Histogram of f0');

%%%
%timfr %%%scrive la label, dimensioni
%plot(timfr,'.')
%ax=x_gd(timfr);
%ay=y_gd(timfr);
%% Integral histogram: sum over the bins
j=1;
binh_f0(j)=bin_f0(j);
j=2;
while j <=nbin_f0
    binh_f0(j)=0;
    binh_f0(j)=binh_f0(j-1)+bin_f0(j);
    j=j+1;
end
% Integral histogram of the matrix bin_df0: sum over the f0 bins, for each spin-down (d) value
binh_df0=zeros(nbin_d,nbin_f0);
i=1;  %%spin down bins
while i <= nbin_d
j=1;  %f0 bins
binh_df0(i,j)=bin_df0(i,j);
j=2;
while j <=nbin_f0
    %%binh_df0(i,j)=0; put to zeros before
    binh_df0(i,j)=binh_df0(i,j-1)+bin_df0(i,j);
    j=j+1;
end
i=i+1
end
%Construct a gd type 2 with the integral histogram
hfdfh=gd(binh_f0);
hfdfh=edit_gd(hfdfh,'dx',f0_res,'ini',f0band(1),'capt','Histogram of f0');
figure
plot(hfdfh,'.')
title('Integral istogram of f_0')
xlabel('f_0 in Hz')
ylabel('N')
%Construct a gd2 for the integral matrix, with d on the y
hdf0=gd2(binh_df0') %%to have, in the map the spin-down on y and f0 on x
hdf0=edit_gd2(hdf0,'dx',f0_res,'ini',f0band(1),'dx2',deltad,'ini2',dmin,'capt','Histogram of spin-f0');
%%map_gd2(hdf0)  %%log, non si vede bene
xgd=x_gd(timfr);
ygd=y_gd(timfr);
figure
hist(ygd,1000); %%Istogram of the original peakmap in the selected band
grid
clear timfr
clear hfdf
clear hfdfh
clear xgd
clear ygd
clear f0a
clear f0b
clear bin*
y=y_gd2(hdf0);
figure
a1=ini_gd2(hdf0)          %inizial f0 freq
a2=ini2_gd2(hdf0)         %initial spin down value
dx1=dx_gd2(hdf0)          %step in f0
dx2=dx2_gd2(hdf0)         %step in spin-down
m=m_gd2(hdf0)             %number of spin-down values
n=size(y)                 %comp 1 is number of frequencies
n1=n(1)
i1=0:n-1;
i2=0:m-1;
x1=a1+i1*dx1;
x2=a2+i2*dx2;
image(x1,x2,y')
colorbar
%colormap cool
grid on
zoom on
xlabel('f_0 [Hz]')
ylabel('spin-down [Hz/s]')
%figure
%grid
%plot(dx,y,'.')
%figure
%%surf(y)  non farlo,l si impalla se troppi dati !!
thres=40
nmax=1000
%Lasciare nel codice o fare un' altra function. Comunque funziona
%19/settembre 07
%xp is the frequency, yp the spin-down (first and second abscissae)
%zp is the value of the maximum
[xp,yp,zp]=twod_peaks(hdf0,thres,nmax,1);
figure
plot(zp,xp,'*b')
ylabel('f_0')
xlabel('Intensity of the max')
grid
figure
plot(zp,yp,'*r')
ylabel('spin down')
xlabel('Intensity of the max')
grid
figure
plot3(xp,yp,zp,'*r')
grid
title('Peaks on hdf0 found with twod-peaks')
xlabel('f_0')
ylabel('spin-down')
zlabel('Intensity of the max')
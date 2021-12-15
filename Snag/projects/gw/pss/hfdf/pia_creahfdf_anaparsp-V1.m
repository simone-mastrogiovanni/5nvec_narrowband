function [xp_tot,yp_tot,zp_tot,hdf1,dfr,frband]=pia_creahfdf_anaparsp(res,edge,dmin,dmax,kdeltaf)
%PIA_creahfdf from a vbl-file peakmap creates, using pia_creatimfr, a hough
%tranformation to the plane (f0,fdot)
%
% In a vbl-file the first channel is the parameters, the second the bins,
% the third the amplitudes; other channels can contain short spectra and
% other.
%
%   res  =0  -->1
%   edge   <=0  -->0.00001
%   dmin,dmax  min,max spindown values. Hz/s; =0  0--> dmin=-0.1  dmax=0.1
%   ATTENZIONE: 0,0 default su d va bene solo ora per le mie prove. Dovremo
%   fare diversamente !!!  Sergio e' d'accordo ! 24/08/07
% kdeltaf = factor to get, from dfr, the deltaf bandwith over which to look for f0
% =0 -->1 used for instrumental disturbances
%
%   frband         bandwidth of the signal
%   dfr            frequency resolutin, Hz
%   hdf0           output (a gd2 , with f0 and fdot )
% Version xx - 8 October 2007
% by Pia
% E.g. 
%      [xp_tot,yp_tot,zp_tot,hdf1,dfr,frband]=pia_creahfdf_anaparsp(10,0,0,0,0);
% cd c:\matlab\hough-pia
format long
DTRUE=0.0050
lines(1).fr=50;
lines(1).d=DTRUE;
% lines(1).amp=10;
lines(1).amp=1000;
par.nt=500;
par.nfr=1000;
par.dt=1;
par.dfr=0.2;  %%0.1
% par.thresh=4;
par.thresh=40;
timfr_sim=crea_linpm(lines,par);
clear lines;
clear par;
MAXLOOP=20   %number of loops around the true spin-down
%%Set default values on the parameters, if needed
scale=2*10^6;  %%factor which multiplies deltad, when used...
if res == 0
    res=1.0;
end
if edge <= 0
    edge=0.00001;
end
if (dmin==0 && dmax==0)
    dmin=-1.5*DTRUE;
    dmax=1.5*DTRUE;
end
thr=0;
time=0;
%%%Read the time-frequency gd and creates two vectors and parameters
%% AND 
%%Set parameters, using the information read in the peakmap and given in noput
tim_tot=x_gd2(timfr_sim);
dfr=dx2_gd2(timfr_sim)  %freq. step
ddays=dx_gd2(timfr_sim)  %time (days) step
t0=tim_tot(1);
tim_tot=(tim_tot-t0)*ddays;
A=y_gd2(timfr_sim); 
[ff,tt,aa]=find(A');
frini=ini_gd2(timfr_sim)
observation_time=max(tim_tot)+1;
tmax=observation_time
ff=(ff-1)*dfr;  %%IMP !! Per come funziona linpm
tt=tt*ddays;
n=n_gd2(timfr_sim);
nfr=m_gd2(timfr_sim);  %number of frequencies
nt=n/nfr;       %number of days       
a=frini;
b=(nfr-1)*dfr;
f0band=[a b]   %per prova attenzione !
factor=1;
if dmax < 0
    factor=0;
end
if kdeltaf==0
     kdeltaf=1;
end
frband(1)=f0band(1)*(1-edge)-factor*tmax*dmax;
if frband(1) < 0
    frband(1)=0
end
factor=1;
if dmin > 0
    factor=0;
end
frband(2)=f0band(2)*(1-edge)-factor*tmax*dmin;
frband
f0_central=(f0band(2)-f0band(1))/2
%f0_res is the resolution for f0:
f0_res=dfr/res;
clear timfr_sim
%Deltad is the spin-down resolution. Depends on the observation time
% 2 ottobre 07: put to a value convenient for crea_linpm --simulation
deltad=2*DTRUE/40;
%%deltad= scale*dfr/(observation_time*86400)  %%uncomment for true analyses
%Deltaf is the bandwidth around freq on which to look to construct f0
deltaf= dfr*kdeltaf
%%%%%%%%%Evaluation of the number of bins and inizialization (=0)of the bin contents in the differential histogram%%%%%%%%%%%%%%%%
nbin_f0=round(1+(f0band(2)-f0band(1))/f0_res);
nbin_fr=round(1+(frband(2)-frband(1))/dfr);
nbin_d=round(2+(dmax-dmin)/deltad)  %%direi 2 per prendere sia dmin che dmax. Verificare
%Direct-Differentail histogram construction
%Differential (easier to be constructed)
tim_tot=tt-t0;
freq_tot=ff;
n_of_ff=size(ff);
nloop=MAXLOOP;
imin=-round(nloop/2);
imax=-imin;
lenyy=imin*2+1;
yya=zeros(1,lenyy);
xx=yya;
yyf=yya;
yyd=yya;
iloop=imin;
%Begin of the two loops
fac=1/100000;
iii=0;
while iloop <= imax
    iii=iii+1;
    clear bin* 
    bin_df0(round(nbin_d),round(nbin_f0))=0;  %%matrix for both spin-down and f_0 
    ispin=0;
    d=dmin;
    dmin1=dmin+iloop*deltad/nloop;
    xx(iii)=dmin1;
    while d <= dmax       
        d=dmin1+ispin*deltad;
        if (d>= DTRUE-fac) &&  (d<= DTRUE+fac)
%             disp('ciao')
%         end
%         if (d>= DTRUE-fac*100) &&  (d<= DTRUE+fac*100)
            d,DTRUE,iloop,fac,deltad,iloop
        end
        ispin=ispin+1;
        for i=1:n_of_ff(1)
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
            bin_df0(c,a)=bin_df0(c,a)+1;
            bin_df0(c,b)=bin_df0(c,b)-1;
        end   
    end
% bin_df0(:,1) e.g. to see ...
%Construct a gd type 2 with the differential histogram
%timfr %%%scrive la label, dimensioni
%plot(timfr,'.')
%ax=x_gd(timfr);
%ay=y_gd(timfr);
% IMPORTANT: Integral histogram of the matrix bin_df0: sum over the f0 bins, for each spin-down (d) value
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
        i=i+1;
    end
%Construct a gd type 2 with the integral histogram
%IMPORTANT hdf0: Construct a gd2 for the integral matrix, with d on the y
    clear hdf0;
    hdf0=gd2(binh_df0'); %%to have, in the map the spin-down on y and f0 on x
    hdf0=edit_gd2(hdf0,'dx',f0_res,'ini',f0band(1),'dx2',deltad,'ini2',dmin1,'capt','Histogram of spin-f0');
    %%map_gd2(hdf0)  %%log, non si vede bene
    if iloop == 0
        hdf1=hdf0;
    end
    if iloop == imin
        figure
        hist(ff,1000); %%Istogram of the original peakmap in the selected band
        grid on
    end
    if abs(iloop) <= 1    %%Three figures for example 
        y=y_gd2(hdf0);
        a1=ini_gd2(hdf0);           %inizial f0 freq
        a2=ini2_gd2(hdf0);          %initial spin down value
        dx1=dx_gd2(hdf0);           %step in f0
        dx2=dx2_gd2(hdf0);          %step in spin-down
        m=m_gd2(hdf0);              %number of spin-down values
        n=size(y);                  %comp 1 is number of frequencies
        n1=n(1);
        i1=0:n-1;
        i2=0:m-1;
        x1=a1+i1*dx1;
        x2=a2+i2*dx2;
        figure
        image(x1,x2,y')
        colorbar
        %colormap cool
        grid on
        zoom on
        xlabel('f_0 [Hz]')
        ylabel('spin-down [Hz/s]')
        if iloop == 0
            title('Recovered with exact spin down value. iloop 0')
        end
        if iloop == 1 
            title('Recovered with non-exact spin-down value. iloop 1')
        end
        if iloop == -1 
            title('Recovered with non-exact spin-down value. iloop -1')
        end
        if iloop == 0 
            fn='figures/simulated_map_exactspindown';
            print ('-depsc',fn)  %%%per l'eps
            print ('-djpeg',fn)  %%%per jpg
        end
       if iloop == -1
            fn='figures/simulated_map_wrongspindown1';
            print ('-depsc',fn)  %%%per l'eps
            print ('-djpeg',fn)  %%%per jpg
       end 
       if iloop == 1
            fn='figures/simulated_map_wrongspindown2';
            print ('-depsc',fn)  %%%per l'eps
            print ('-djpeg',fn)  %%%per jpg
        end  
    end
%figure
%grid
%plot(dx,y,'.')
%figure
%%surf(y)  non farlo,l si impalla se troppi dati !!
%%To have median,mean,std of ALL the data
    thres=20;
    nmax=100;
    %Lasciare nel codice o fare un' altra function. Comunque funziona
    %19/settembre 07
    %xp is the frequency, yp the spin-down (first and second abscissae)
    %zp is the value of the maximum
    [xp,yp,zp]=twod_peaks(hdf0,thres,nmax,1);
    yya(iii)=zp(1);
    yyf(iii)=xp(1);
    yyd(iii)=yp(1);
    if abs(iloop) == 0
        iloop;
        figure
        plot(zp,xp,'*b')
        ylabel('f_0')
        xlabel('Intensity of the max')
        grid on
        figure
        plot(zp,yp,'*r')
        ylabel('spin down')
        xlabel('Intensity of the max')
        grid on
        figure
        plot3(xp,yp,zp,'*r')
        grid on
        if iloop == 0
            title('Peaks on hdf0 found with twod-peaks. iloop=0')
        end
        if iloop == -1
            title('Peaks on hdf0 found with twod-peaks. iloop=-1')
        end
        if iloop ==1
            title('Peaks on hdf0 found with twod-peaks. iloop=1')
        end
        xlabel('f_0')
        ylabel('spin-down')
        zlabel('Intensity of the max')
        if iloop == 0 
            fn='figures/simulated_plot3_exactspindown';
            print ('-depsc',fn)  %%%per l'eps
            print ('-djpeg',fn)  %%%per jpg
        end
       if iloop == -1
            fn='figures/simulated_plot3_wrongspindown1';
            print ('-depsc',fn)  %%%per l'eps
            print ('-djpeg',fn)  %%%per jpg
       end 
       if iloop == 1
            fn='figures/simulated_plot3_wrongspindown2';
            print ('-depsc',fn)  %%%per l'eps
            print ('-djpeg',fn)  %%%per jpg
        end  
    end
    appo=size(xp);
    nshow=appo(2);
    if nshow >= 3
       nshow =3;
    end
    iloop
    show_twod_peaks(xp,yp,zp,nshow);
    acc=(DTRUE-dmin1)/deltad;
    acc=round(acc)*deltad+dmin1;
    disp(sprintf('%12.9f  %12.9f  %12.9f',dmin1,deltad,acc))
    if iloop == imin
        xp_tot=xp;
        yp_tot=yp;
        zp_tot=zp;
    else
        xp_tot=[xp_tot xp];
        yp_tot=[yp_tot yp];
        zp_tot=[zp_tot zp];
    end
    iloop=iloop+1;
end

figure
plot3(xp_tot,yp_tot,zp_tot,'*')
%%%Proiezioni
grid on
zoom on
xlabel('f_0 [Hz]')
ylabel('spin-down [Hz/s]')
zlabel('Intensity of the maximum (plus the two nearests values)')
title('Total plot3, scanning values of spindown, around the true value')
fn='figures/simulated_plot3_spindowns';
print ('-depsc',fn)  %%%per l'eps
print ('-djpeg',fn)  %%%per jpg
plot_triplets(xp_tot,yp_tot,zp_tot,'*')
plot_triplets(xp_tot,zp_tot,yp_tot,'*')
k0=find(zp_tot==max(zp_tot));
xp_tot(k0),yp_tot(k0),zp_tot(k0)
ctot=[xp_tot',yp_tot',zp_tot'];
%c(1,1),c(1,2),c(1,3)
m=size(xp_tot)-1;
stepx=(max(xp_tot)-min(xp_tot))/m(2);
stepy=(max(yp_tot)-min(yp_tot))/m(2);
dx_tot=min(xp_tot):stepx:max(xp_tot);
dy_tot=min(yp_tot):stepy:max(yp_tot);
% figure
%%no image(xp_tot,yp_tot,zp_tot)
% image(dx_tot,dy_tot,ctot)
% colorbar
% %colormap cool
% grid on
% zoom on
% xlabel('f_0 [Hz]')
% ylabel('spin-down [Hz/s]')
% title('Values of spindown, around the true value')
% fn='figures/simulated_map_spindowns';
% print ('-depsc',fn)  %%%per l'eps
% print ('-djpeg',fn)  %%%per jpg
xx=xx(1:iii)-dmin;
yya=yya(1:iii);
yyf=yyf(1:iii);
yyd=yyd(1:iii);

figure, plot(xx,yyf),grid on
figure, plot(xx,yyd),grid on
figure, plot(xx,yya),grid on

mean(yya)
function [xp_tot,yp_tot,zp_tot,hdf1,dfr,frband,yya,yyf,yyd,yylambda,yybeta,yysource_lam,yysource_bet]=pia_creahfdf_randomsources(res,edge,dmin,dmax,kdeltaf)
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
%   dfr            frequency resolution, Hz
%   hdf0           output (a gd2 , with f0 and fdot )
% Version xx - 8 October 2007
% by Pia
% E.g. 
%      [xp_tot,yp_tot,zp_tot,hdf1,dfr,frband,yya,yyf,yyd,yylambda,yybeta,yysource_lam,yysource_bet]=pia_creahfdf_randomsources(10,0,0,0,0);
% cd c:\matlab\hough-pia
nsources=50;
sourstr.N=nsources;
sourstr.fr=[50.0 50.0];
sourstr.sd1=[0. 0.];
sourstr.sd2=[0. 0.];
sourstr.amp=[100 100];
sourstr.eps=[0 0];
sourstr.psi=[0 0];
sourstr.alpha=[0 360];
sourstr.delta=[-90 90];
%
%  sourstr    structure array for source creation; each structure contains:
%     .N      number of sources
%     .fr     [min max] frequency (at epoch 2000-1-1 0:0)
%     .sd1    [min max] first spin down parameter (Hz/day)
%     .sd2    [min max] second spin down parameter (Hz/day^2)
%     .amp    [min max] amplitude
%     .eps    [min max] percentage of linear polarization
%     .psi    [min max] linear polarization angle
%     .alpha  [min max] alpha (equatorial coordinates)
%     .delta   [min max] delta  (equatorial coordinates)
%
%  outfile    output file
fcand=pss_creasourcefile(sourstr);
% PSS_CREASOURCEFILE  creates source file
npoints=3;
%%The detector is Virgo
    %Virgo coordinates
    antenna.lat=43+37/60+53/3600; %deg
    antenna.long=10+30/60+16/3600; %deg
%%Creation of the optimal sky map. Needed to construct the grid
ND=100*1.4142
[map,b]=pss_optmap(ND,1);
% [map,b]=pss_optmap_pia(ND);
yya=zeros(1,nsources);
xx=yya;
yyf=yya;
yyd=yya;
yylambda=yya;
yybeta=yya;
 iii=0;
for nnn=1:nsources
    sour.lam=fcand(2,nnn); %Eclittica 0,0
    sour.bet=fcand(3,nnn);
    [center,borders]=check_optmap(map,sour);
    lambda_grid=center(1,1);
    bet_grid=center(1,2);
    if edge <= 0
        edge=0.00001;
    end
    dt=86400*1.5;
    n=500;
    dfr=0.001;
    nfr=1000;
    inifr=499.5;
    observation_time=(n-1)*dt;
    step_sd=dfr/observation_time;
    % step_sd=2.5e-7/5;

    %% sorgente
    DTRUE=step_sd*0;  %*25
    % DTRUE=1e-7
    lines(1).fr=500;
    lines(1).d=DTRUE;
    lines(1).amp=1000;
    lines(1).lat=sour.bet;
    lines(1).long=sour.lam;

    par.nt=n;
    par.nfr=nfr;
    par.dt=dt;
    par.dfr=dfr;
    par.inifr=inifr;
    par.thresh=40; %%lines,par
    timeini=54247.0;   %%mjd = 27/05/2007
    %Creation of the peakmap with the simulated signal
    [timfr_simdoppler,va,vd,ve]=crea_linpm_doppler(lines,par,antenna,timeini); % plot(timfr_simdoppler)
    %Doppler correction
    %Detector velocities
    %[va,ve,vd]=get_gd2_vdetect(timfr_simdoppler); %from the sim gd2 extract vectors of det vel, for each spectrum

%     %State parameters for the Doppler correction
%     step_bet1=(borders(1,2)-center(1,2))/npoints;
%     step_bet2=(center(1,2)-borders(3,2))/npoints;
%     step_lam=(borders(2,1)-borders(1,1))/(2*npoints);
%     minlam=borders(1,1);
%     maxlam=borders(2,1);
%     maxbet=borders(1,2);
%     minbet=borders(3,2);

    A=y_gd2(timfr_simdoppler); 
    [ff,tt,aa]=find(A');
    ff=(ff-1)*dfr+inifr; 
    tt=(tt-1)*dt;
    nt=n/nfr;              
    tim_tot=tt-min(tt);
    observation_time=max(tim_tot);
    n_of_ff=length(ff);
    peaks(2,:)=ff;
    peaks(1,:)=tim_tot;%plot(peaks(1,:),peaks(2,:),'.'),grid on
    a=inifr-round(nfr/2)*dfr; 
    b=inifr+round(2*nfr/2)*dfr;  
    f0band=[a b];   


    %% mappa di Hough

    scale=2*10^6;  %%factor which multiplies deltad, when used...
    if res == 0
        res=1.0;
    end
    %Deltad is the spin-down resolution. Depends on the observation time

    deltad= scale*dfr/observation_time; %Not used now
    deltad=step_sd;

    if (dmin==0 && dmax==0)
        dmin=-150*deltad;
        dmax=-dmin;
    end

    thr=0;
    time=0;
    %Read the time-frequency gd and creates two vectors and parameters
    % AND 
    %Set parameters, using the information read in the peakmap and given in noput

    %% casini vari sulla banda

    factor=1;
    if dmax < 0
        factor=0;
    end
    if kdeltaf==0
         kdeltaf=1;
    end
    frband(1)=f0band(1)*(1-edge)-factor*observation_time*dmax;
    if frband(1) < 0
        frband(1)=0;
    end
    factor=1;
    if dmin > 0
        factor=0;
    end
    frband(2)=f0band(2)*(1-edge)-factor*observation_time*dmin;
    if frband(2) > nfr*dfr+inifr            %%Attenzione: per ora viene sempre cosi', frband=f0band 
        frband(2)=nfr*dfr+inifr;             %%11 ott 07 per come ho fatto su f0_band. Capire,cambiare
    end
    f0band;
    frband;
    % f0_central=(f0band(2)-f0band(1))/2
    %f0_res is the resolution for f0:
    f0_res=dfr/res;
    clear timfr_sim
    %Deltaf is the bandwidth around freq on which to look to construct f0
    deltaf= dfr*kdeltaf;
    %%%%%%%%%Evaluation of the number of bins and inizialization (=0)of the bin contents in the differential histogram%%%%%%%%%%%%%%%%

    nbin_f0=round((f0band(2)-f0band(1))/f0_res);

    %% Altri casini


    dmin0=dmin-deltad/2;   %Minumum of all the used dmin
    dmax0=dmax+deltad/2;   %Max of all the used dmax
    %Bins of d  related to dmin and dmax, or to dmin0 and dmax0 ??
    nbin_d=round((dmax-dmin)/deltad);
    lenyy=npoints*2+1;
    
    %Begin of the two loops
    fac=1/100000;

    hmap.fr=[f0band(1) deltaf res nbin_f0];%plot(peaks(1,:),peaks(2,:),'.'),grid on
    thres=20;
    nmax=100;
    %%External loop= doppler correction (evaluat. of factdop) Internal loop: Hough trasform
   
        beta=bet_grid;
        lambda=lambda_grid;
         factdop=doppler_correction(timfr_simdoppler,lambda,beta,va,ve,vd);
         %% Hough loop
            iii=iii+1;
            dmin1=dmin;
            xx(iii)=dmin1;
            hmap.d=[dmin1 deltad nbin_d];
            hdf0=hfdf_hough(hmap,peaks,factdop);
            if (iii== 1)  %%the first for example
                hdf1=hdf0
                figure
                hist(ff,1000); %%Istogram of the original peakmap in the selected band
                grid on
                figure   
                plot(hdf0)
                xlabel('f_0 [Hz]')
                ylabel('spin-down [Hz/s]')
                title('Recovered with exact spin down value')          
            end
            [xp,yp,zp]=twod_peaks(hdf0,thres,nmax,1);
            yya(iii)=zp(1);
            yyf(iii)=xp(1);
            yyd(iii)=yp(1);
            yylambda(iii)=lambda;    %%grid values
            yybeta(iii)=beta;
            yysource_lam(iii)=sour.lam;  %%injected values
            yysource_bet(iii)=sour.bet;
            if (iii==1) 
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
                title('Peaks on hdf0 found with twod-peaks. iloop=0')               
                xlabel('f_0')
                ylabel('spin-down')
                zlabel('Intensity of the max')
            end
            nshow=length(xp);
            if nshow >= 3
               nshow =3;
            end
            show_twod_peaks(xp,yp,zp,nshow);
            disp(sprintf('%9.6f  %9.6f  %9.6f %9.6f %f',lambda,beta,sour.lam,sour.bet,iii))
            if iii == 1
                xp_tot=xp;
                yp_tot=yp;
                zp_tot=zp;
            else
                xp_tot=[xp_tot xp];
                yp_tot=[yp_tot yp];
                zp_tot=[zp_tot zp];
            end
       
end

%% finale

figure
plot3(xp_tot,yp_tot,zp_tot,'*')
%%%Proiezioni
grid on
zoom on
xlabel('f_0 [Hz]')
ylabel('spin-down [Hz/s]')
zlabel('Intensity of the 3-maxima (3- means max and the two nearests values)')
title('3-d plot, scanning values of spindown, around the true value')
% fn='figures/simulated_plot3_spindowns';
% print ('-depsc',fn)  %%%per l'eps
% print ('-djpeg',fn)  %%%per jpg
plot_triplets(xp_tot,yp_tot,zp_tot,'*')
xlabel('f_0 [Hz]')
ylabel('spin-down [Hz/s]')
title('Colour : intensity of the 3-maxima')
plot_triplets(xp_tot,zp_tot,yp_tot,'*')
xlabel('f_0 [Hz]')
title('Colour : spin-down values[Hz/s]')
ylabel('Intensity of the 3-maxima')
k0=find(zp_tot==max(zp_tot));
xp_tot(k0),yp_tot(k0),zp_tot(k0)
m=length(xp_tot)-1;
stepx=(max(xp_tot)-min(xp_tot))/m;
stepy=(max(yp_tot)-min(yp_tot))/m;
dx_tot=min(xp_tot):stepx:max(xp_tot);
dy_tot=min(yp_tot):stepy:max(yp_tot);
xx=xx(1:iii)-dmin;
yya=yya(1:iii);
yyf=yyf(1:iii);
yyd=yyd(1:iii);
yylambda=yylambda(1:iii);
yybeta=yybeta(1:iii);
plot_triplets(yylambda,yybeta,yya,'*')
xlabel('longitude  $\lambda$ [deg]')
ylabel('latitude $\beta$ [deg]')
title('Colour : intensity of the maxima')
plot_triplets(yylambda,yybeta,yyf,'*')
xlabel('longitude  $\lambda$ [deg]')
ylabel('latitude $\beta$ [deg]')
title('Colour : frequency of the maxima')
plot_triplets(yylambda,yybeta,yyd,'*')
xlabel('longitude  $\lambda$ [deg]')
ylabel('latitude $\beta$ [deg]')
title('Colour : spin-down of the maxima')
% figure, plot(xx,yyf),grid on
% xlabel('Spin down d minus dmin  [Hz/s]')
% ylabel('Frequency [Hz]')
% title('Freq. of the signal vs (d minus dmin), on the found maxima')
% figure, plot(xx,yyd),grid on
% xlabel('Spin down (d minus dmin)  [Hz/s]')
% ylabel('Spin down [Hz/s]')
% title('d vs (d minus dmin), on the found maxima')
% figure, plot(xx,yya),grid on
% xlabel('Spin down (d minus dmin)  [Hz/s]')
% ylabel('Intensity of the maxima')
% title('Intensity vs (d minus dmin), on the found maxima')
mediayya=mean(yya);
mediayyf=mean(yyf);
mediayyd=mean(yyd);
mediayylambda=mean(yylambda);
mediayybeta=mean(yybeta);
disp(sprintf('Mean: amplitude; freq; spin-down; long; lat'))
disp(sprintf('%9.6f  %9.6f  %9.6f %9.6f %9.6f',mediayya,mediayyf,mediayyd,mediayylambda,mediayybeta))

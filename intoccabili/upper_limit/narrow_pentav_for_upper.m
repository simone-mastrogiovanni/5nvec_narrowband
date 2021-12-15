function [Sfft Sfftshifted hvectors fra1 info gg_sc_clean]=narrow_pentav_for_upper(selpath,gg_sc,sour,ant,ext2,freqint,inseg,thr,sourcestr)

% NARROW_PENTAV function to compute the detection statistic over a frequency band
% using Matlab fft (rigrid the frequency as sub-multiple of sideral frequency)
%
% by Simone Mastrogiovanni, 2016

% Input arguments:

% selpath: Path of the main folder,usually the folder where you are
%          working
% gg_sc: time series corresponding to a given spin-down value, non-science
%        data are already putted to zero.
% sour:  source structure
% ant:   detector structure
% ext2:  array containing the extremes of the frequency band to be
% freqint: Integer part of frequency ,rounded from the ext(1) as frasca in
%          band extraction
% inseg: path to the Science Segments list file
% thr: threshold for outlier removal
% sourcestr: String name of the source

% Output arguments:

% Sfft: array with detection statistic values for all the frequencies
% Sfftshifted: DS computed with the signal fft in the interbins.
% hvcetors: Structure with the two quantities H+/x , same grid of Sfft and
%           fftshifted
% fra1: Frequency array corresponding to Sfft, H+/x, for shifted
%       conversion( shiftedfreq=fra1+0.5*binfsid)
% allffts: Strucutre containing the complete series of fft, use for compute noisedistribution
% info: Structure with useful quantities to compute noise distribution
% gg_sc_clean: cleaned time series
%
% Output files:
% Files with the penta-vecto of the sidereal templates in the specified
% path


% remove outliers from the time series, gg_sc no longer used
%gg_sc_clean=rough_clean(gg_sc,-thr,thr);
gg_sc_clean=gg_sc; % Dont' apply the thr at all

clear gg_sc
% extracts data and times from the clean time series
y=y_gd(gg_sc_clean);
t=x_gd(gg_sc_clean);
N=length(y); % number of samples
dt=dx_gd(gg_sc_clean);% sampling time
nsid=10000; % number of points at which the sidereal response will be computed
SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency



%$$$$$The block is used to define a new bin and Tobs%%%%%%%%%
binf=1/(N*dt); %$ Frequency bin due to the length of signal series
nsidbin=floor(FS/binf); %$ Number of corrisponding to sidereal freq
binfsid=FS/nsidbin; %$New bin Submultiple of Sidereal freq
Tsid=1/binfsid; %$ New observation time

NS=round(Tsid/dt); %$ Number of components in the arraya to save
binfsid=1/(NS*dt);
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

y=y(1:NS,1); %$ New signal array corresponding to the new observational time
t=t(1:NS,1); %$ New signal array corresponding to the new observational time
gg_sc_clean=edit_gd(gg_sc_clean,'y',y,'x',t); %$ Re-edit the gd
y=y.'; %$ Traspose for some operation in compact form
t=t.'; %$ Traspose for some operation in compact form
%save('inj_prova.mat','y')

cont=cont_gd(gg_sc_clean); % input data cont structure
t0=cont.t0; % Start time of data
fr=cont.appf0; % reference search frequency
fr0=fr-freqint; % fractional part of the signal frequency
obs=check_nonzero(gg_sc_clean,1); % array of 1s (when data sample is non-zero) and zeros
shifttime=cont.shiftedtime; % Read the new reference time

fr0bin=round(fr0/binfsid)*binfsid;%$ Rigrid the frequency of the source structure
ext2bindown=round(ext2(1)/binfsid)*binfsid; %$ Rigrid the inferior extreme
ext2binup=round(ext2(2)/binfsid)*binfsid; %$ Rigrid the superior extreme
% generate signal templates and compute corresponding 5-vects
ph0=mod(fr0bin*t,1)*2*pi;%$ Signal phase fot template
stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response

Aplus=sid1(isub).*exp(1j*ph0); % + signal template
Across=sid2(isub).*exp(1j*ph0); % x signal template
Aplus=Aplus.*obs'; %$ Put to zero the components corresponding to NAN
Across=Across.*obs'; %$ Put to zero the components corresponding to NAN


% for jj=1:1:5
%    DFT_Ap(jj)=sum(Aplus.*exp(-2*pi*1i*(fr0bin+(jj-3)*FS)*dt*(0:NS-1))); 
%    DFT_Ac(jj)=sum(Across.*exp(-2*pi*1i*(fr0bin+(jj-3)*FS)*dt*(0:NS-1)));
%     
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


nbin_fs=round(FS/binfsid); %$ Number of bin corresponding to sidereal freq

nbin_down=round(ext2bindown/binfsid)+1; %$
nbin_up=round(ext2binup/binfsid)+1; %$

%nbin_up-2*nbin_fs-(nbin_down+2*nbin_fs)

%$ Just a control, stop if the band is not big enough to contain sidereal
%freq.
if(nbin_up-2*nbin_fs<nbin_down+2*nbin_fs)
    dips('band too small');
    stop;
    
end


fra=ext2bindown:binfsid:ext2binup;%$ Construzione della griglia
fra1=fra(round(2*nbin_fs+1):end-2*round(nbin_fs)); %$ Grid corresponding to Sfft
%$ COMPUTE FFTs OF  DATA $$$$
signalfft=fft(y);


signalfft1=signalfft(nbin_down:nbin_up);
% for ss=1:1:length(fra1)
%     for ijj=1:1:5
%    vec_5_prova(ijj)=sum(y.*exp(-2*pi*1i*(fra1(ss)+(ijj-3)*FS)*dt*(0:NS-1)));
%     end
%    DFT_Hp(ss)=sum(vec_5_prova.*conj(DFT_Ap));
%    DFT_Hc(ss)=sum(vec_5_prova.*conj(DFT_Ac));
%    DFT_Ap2=(norm(DFT_Ap))^2;
%    DFT_Ac2=(norm(DFT_Ac))^2;
%    DFT_Hp(ss)=DFT_Hp(ss)/DFT_Ap2;
%    DFT_Hc(ss)=DFT_Hc(ss)/DFT_Ac2;
% end
signalfft1_shift=signalfft1.*exp(-1j*mod(2*pi*fra*shifttime,2*pi)); % Adjust the frequency components to the new reference time
signalfftshifted=-(1.0/4.0)*pi*diff(signalfft1); % Interpolate the half bin frequency components
signalfft1=signalfft1_shift;
signalfftshifted=[signalfftshifted,0];
signalfftshifted=signalfftshifted.*exp(-1j*mod(2*pi*(fra+0.5*binfsid)*shifttime,2*pi)); % Adjust the frequency components to the new reference time
%
% if exist([selpath,'noise_peaks.txt'],'file')
%    fp=fopen([selpath,'noise_peaks.txt'],'r');
%    locpeak=textscan(fp,'%f %f','Delimiter','\t');
%    peakfreq=locpeak{1}
%    peakwidth=locpeak{2}
%    for count=1:1:length(peakfreq)
%     if((peakfreq(count)-freqint)>0  && (peakfreq(count)-freqint)<(1/dt))
%            peakfreq(count)
%            peakwidth(count)
%            od=round((peakfreq(count)-freqint-peakwidth(count))/binfsid)+1
%            ou=round((peakfreq(count)-freqint+peakwidth(count))/binfsid)+1
%            signalfft(od:ou)=0;
%     end
%
%    end
%    fclose(fp);
% end




%$ fft in the interested band


m2=1:length(signalfft1)-4*nbin_fs;
m1=m2+nbin_fs;
m0=m1+nbin_fs;
p1=m0+nbin_fs;
p2=p1+nbin_fs;

nbin_max=round(fr0bin/binfsid)+1;

%$ Computation of the sidereal templates $$$$$$$$

if ~exist([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'forupper_templates.mat'],'file')
    Aplusfft=fft(Aplus);
    Acrossfft=fft(Across);
    
    pentaAplusfft=[ Aplusfft(round(nbin_max-2*nbin_fs)); Aplusfft(round(nbin_max-nbin_fs));Aplusfft(round(nbin_max));Aplusfft(round(nbin_max+nbin_fs));Aplusfft(round(nbin_max+2*nbin_fs))];
    
    pentaAcrossfft=[ Acrossfft(round(nbin_max-2*nbin_fs));Acrossfft(round(nbin_max-nbin_fs));Acrossfft(round(nbin_max)); Acrossfft(round(nbin_max+nbin_fs)); Acrossfft(round(nbin_max+2*nbin_fs)) ];
    
    pentaAplusfft=pentaAplusfft.*exp(-1j*mod(2*pi*[fr0bin-2*FS;fr0bin-1*FS;fr0bin;fr0bin+1*FS;fr0bin+2*FS]*shifttime,2*pi)); % Adjust the frequency components to the new reference time
    pentaAcrossfft=pentaAcrossfft.*exp(-1j*mod(2*pi*[fr0bin-2*FS;fr0bin-1*FS;fr0bin;fr0bin+1*FS;fr0bin+2*FS]*shifttime,2*pi)); % Adjust the frequency components to the new reference time
    
    Ap2=(norm(pentaAplusfft))^2;
    Ac2=(norm(pentaAcrossfft))^2;
    
    save([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'forupper_templates.mat'],'pentaAplusfft','pentaAcrossfft');
end


if exist([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'forupper_templates.mat'],'file')
    load([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'forupper_templates.mat'],'pentaAplusfft','pentaAcrossfft');
    Ap2=(norm(pentaAplusfft))^2;
    Ac2=(norm(pentaAcrossfft))^2;
end
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% for i=1:1:5
%     pentaAcrossfft(i,1)=sum(Across.*exp(-2*pi*1j*(fr0bin+(i-3)*FS)*dt*(0:NS-1))*dt);
%     pentaAplusfft(i,1)=sum(Aplus.*exp(-2*pi*1j*(fr0bin+(i-3)*FS)*dt*(0:NS-1))*dt);
% Ap2=(norm(pentaAplusfft))^2;
%     Ac2=(norm(pentaAcrossfft))^2;
%  save('lookatme1.mat','Ap2','Ac2','pentaAcrossfft','pentaAplusfft')
% end


%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


%$Matrix containing the pentavectors in different frequencies corrisponding
%to fra1
pentasignalfft=[ signalfft1(m2); signalfft1(m1); signalfft1(m0); signalfft1(p1); signalfft1(p2) ];

pentasignalfftshifted=[ signalfftshifted(m2); signalfftshifted(m1); signalfftshifted(m0); signalfftshifted(p1); signalfftshifted(p2) ];
%$ Penta vectors for the templates

%$ Compute H+/x for the two grids

hplusfft=((pentasignalfft')*pentaAplusfft);
hcrossfft=((pentasignalfft')*pentaAcrossfft);


hplusfftshifted=((pentasignalfftshifted')*pentaAplusfft);
hcrossfftshifted=((pentasignalfftshifted')*pentaAcrossfft);



hplusfft=conj(hplusfft)/Ap2;
hcrossfft=conj(hcrossfft)/Ac2;

hplusfftshifted=conj(hplusfftshifted)/Ap2;
hcrossfftshifted=conj(hcrossfftshifted)/Ac2;


%%%%%%%%%%%%%%%%%%%%% SOME PARAMETERS INFORMATION %%%%%%%%%%%%%%%%%%%%

info.nbin_max=nbin_max; %$Dove si trova il massimo negli array completi fr0
info.nbin_down=nbin_down; %$ Posizione corrispondente a n2 extinf
info.nbin_up=nbin_up; %$ Posizione corrispondete a nbin_up
info.nbin_fs=nbin_fs; %$ Numero di bin associati alla frequenza siderale
info.binfsid=binfsid; %$ Nuovo bin sottomultiplo della frequenza siderale
info.Tobs=Tsid; %$ Nuovo tempo di ossrvazione
info.fr0bin=fr0bin; %$ Nuova frequenza centrale
info.ext2bindown=ext2bindown; %$ Estremo inferiore della ricerca narrow band
info.ext2binup=ext2binup; %$ Estremo superiore della ricerva narrowband
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


hvectors.hplusfft=hplusfft; %$ Same grid of the FFT
hvectors.hcrossfft=hcrossfft;
hvectors.hplusfftshifted=hplusfftshifted; %$ Same grid of the FFT
hvectors.hcrossfftshifted=hcrossfftshifted;






%$ DS computation $$$$$$

Sfft=abs(conj((pentasignalfft')*pentaAplusfft)).^2+abs(conj((pentasignalfft')*pentaAcrossfft)).^2;
Sfftshifted=abs(conj((pentasignalfftshifted')*pentaAplusfft)).^2+abs(conj((pentasignalfftshifted')*pentaAcrossfft)).^2;

%$ down-sampling correction
Sfft=(dt^4)*Sfft;
Sfftshifted=(dt^4)*Sfftshifted;

%$$$$$$$$$$$$$$$$$$$$$$$
%figure;plot(fra1,Sfft);
%[~,imax]=max(Sfft);
%fra1(imax)-fr0bin
%fra1(imax)-fr0



fra1=fra1+freqint;

end

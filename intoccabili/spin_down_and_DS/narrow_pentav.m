function [Sfft Sfftshifted hvectors fra1 info gg_sc_clean]=narrow_pentav(selpath,gg_sc_clean,sour,ant,ext2,freqint,sourcestr)

% NARROW_PENTAV function to compute the detection statistic over a frequency band
% using Matlab fft ( the frequency bin is a sub-multiple of  the sideral frequency)
%
% by Simone Mastrogiovanni, 2016

% Input arguments:

% selpath: Path of the main folder,usually the folder where you are
%          working
% gg_sc: downsampled time series corresponding to a given spin-down value, non-science
%        data are already put to zero.
% sour:  source structure
% ant:   detector structure
% ext2:  array containing the extremes of the frequency band to be searched
% freqint: Integer part of the searched frequency 
% thr: threshold for outlier removal
% sourcestr: String name of the source

% Output arguments:

% Sfft: array with detection statistic values for all the frequencies
% Sfftshifted: DS computed with the signal fft in the half-bins.
% hvectors: Structure with the two estimated quantities H+/x , same grid of Sfft and
%           Sfftshifted
% fra1: Frequency array corresponding to Sfft, H+/x. For shifted
%       conversion: shiftedfreq=fra1+0.5*binfsid
% info: Structure with useful quantities to compute noise distribution
% gg_sc_clean: cleaned time series
%
% Output files:
% Files with the penta-vectors of the sidereal templates in the specified
% path


% extracts data and times from the clean time series
y=y_gd(gg_sc_clean);
t=x_gd(gg_sc_clean);
N=length(y); % number of samples
dt=dx_gd(gg_sc_clean);% sampling time
nsid=10000; % number of points at which the sidereal response will be computed
SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency

%$$$$$The block is used to define a new bin and Tobs%%%%%%%%%
binf=1/(N*dt); %$ Frequency bin due to the length of time series
nsidbin=floor(FS/binf); %$ Number of bins in the to sidereal frequency
binfsid=FS/nsidbin; %$New bin submultiple of sidereal freq
Tsid=1/binfsid; %$ New observation time

NS=round(Tsid/dt); %$ Number of components in the array to save
binfsid=1/(NS*dt); % Final frequency bin
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

y=y(1:NS,1); %$ New data array corresponding to the new observational time
t=t(1:NS,1); %$ New time array corresponding to the new observational time
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
fr0bin=round(fr0/binfsid)*binfsid;%$ update the frequency of the source structure according to the freq grid
ext2bindown=round(ext2(1)/binfsid)*binfsid; %$ update the inferior extreme according to the freq grid
ext2binup=round(ext2(2)/binfsid)*binfsid; %$ update the superior extreme according to the freq grid
% generate signal templates and compute corresponding 5-vects
ph0=mod(fr0bin*t,1)*2*pi;%$ Signal phase for template
stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response
Aplus=sid1(isub).*exp(1j*ph0); % + signal template
Across=sid2(isub).*exp(1j*ph0); % x signal template
Aplus=Aplus.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data
Across=Across.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data

nbin_fs=round(FS/binfsid); %$ Number of bin in the sidereal freq
nbin_down=round(ext2bindown/binfsid)+1; %$ Bin corresponding to the inferior limit of the explored freq band
nbin_up=round(ext2binup/binfsid)+1; %$ Bin corresponding to the superior limit of the explored freq band

%$ Just a control, stop if the band is not big enough to contain sidereal
%freq.
if(nbin_up-2*nbin_fs<nbin_down+2*nbin_fs)
    dips('band too small');
    exit 
end
% Construction of the freq grid %
fra=ext2bindown:binfsid:ext2binup;
fra1=fra(round(2*nbin_fs+1):end-2*round(nbin_fs));% Adaptation to side bands of the 5-vector
%$ COMPUTE FFTs OF  DATA $$$$
signalfft=fft(y);
%signalfft=signalfft/length(signalfft); % New normalization
signalfft1=signalfft(nbin_down:nbin_up); % Selection of the interested frequency band
signalfft1_shift=signalfft1.*exp(-1j*2*pi*fra*shifttime); % Adjust the frequency components to the new reference time
signalfftshifted=-(1.0/4.0)*pi*diff(signalfft1); % Interpolate the interbin frequency components
signalfft1=signalfft1_shift;
signalfftshifted=[signalfftshifted,0];
signalfftshifted=signalfftshifted.*exp(-1j*2*pi*(fra+0.5*binfsid)*shifttime); % Adjust the interbin  frequency components to the new reference time
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

%$ Arrays needed to build the 5-vector matrixes
m2=1:length(signalfft1)-4*nbin_fs; % Identify position of k=-2 components of the 5-vectors
m1=m2+nbin_fs;
m0=m1+nbin_fs;
p1=m0+nbin_fs;
p2=p1+nbin_fs;

nbin_max=round(fr0bin/binfsid)+1; % Grid position of the central search frequency

%$ Computation of the sidereal templates $$$$$$$$$$$$$$$$

% Load mat file containing template's freq. components
if exist([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'_templates.mat'],'file')
    load([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'_templates.mat'],'pentaAplusfft','pentaAcrossfft');
    Ap2=(norm(pentaAplusfft))^2;
    Ac2=(norm(pentaAcrossfft))^2;
end

% Compute and save the sidereal templates freq. components ( just once at
% the 1st cycle on spin-down loop
if ~exist([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'_templates.mat'],'file')
    Aplusfft=fft(Aplus);
    Acrossfft=fft(Across);
    %Aplusfft=Aplusfft/length(Aplusfft);
    %Acrossfft=Acrossfft/length(Acrossfft);
    %Sidereal 5-vectors
    pentaAplusfft=[ Aplusfft(round(nbin_max-2*nbin_fs)); Aplusfft(round(nbin_max-nbin_fs));Aplusfft(round(nbin_max));Aplusfft(round(nbin_max+nbin_fs));Aplusfft(round(nbin_max+2*nbin_fs))];
    pentaAcrossfft=[ Acrossfft(round(nbin_max-2*nbin_fs));Acrossfft(round(nbin_max-nbin_fs));Acrossfft(round(nbin_max)); Acrossfft(round(nbin_max+nbin_fs)); Acrossfft(round(nbin_max+2*nbin_fs)) ];
   
    pentaAplusfft=pentaAplusfft.*exp(-1j*2*pi*[fr0bin-2*FS;fr0bin-1*FS;fr0bin;fr0bin+1*FS;fr0bin+2*FS]*shifttime); % Adjust the frequency components to the new reference time
    pentaAcrossfft=pentaAcrossfft.*exp(-1j*2*pi*[fr0bin-2*FS;fr0bin-1*FS;fr0bin;fr0bin+1*FS;fr0bin+2*FS]*shifttime); % Adjust the frequency components to the new reference time
    
    Ap2=(norm(pentaAplusfft))^2;
    Ac2=(norm(pentaAcrossfft))^2;
    %Save the sidereal 5-vectors
    save([selpath,num2str(ext2(1)+freqint,'%.4f'),'_',num2str(ext2(2)+freqint,'%.4f'),'_',sourcestr,'_templates.mat'],'pentaAplusfft','pentaAcrossfft');
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


%$Matrix containing the 5-vectors of the data
pentasignalfft=[ signalfft1(m2); signalfft1(m1); signalfft1(m0); signalfft1(p1); signalfft1(p2) ];
pentasignalfftshifted=[ signalfftshifted(m2); signalfftshifted(m1); signalfftshifted(m0); signalfftshifted(p1); signalfftshifted(p2) ];

%$ Compute H+/x estimators 
hplusfft=((pentasignalfft')*pentaAplusfft);
hcrossfft=((pentasignalfft')*pentaAcrossfft);

% Compute iterbin estimators
hplusfftshifted=((pentasignalfftshifted')*pentaAplusfft);
hcrossfftshifted=((pentasignalfftshifted')*pentaAcrossfft);

hplusfft=conj(hplusfft)/Ap2;
hcrossfft=conj(hcrossfft)/Ac2;

hplusfftshifted=conj(hplusfftshifted)/Ap2;
hcrossfftshifted=conj(hcrossfftshifted)/Ac2;


%%%%%%%%%%%%%%%%%%%%% SOME PARAMETERS INFORMATION %%%%%%%%%%%%%%%%%%%%
info.nbin_max=nbin_max; 
info.nbin_down=nbin_down;
info.nbin_up=nbin_up; 
info.nbin_fs=nbin_fs; 
info.binfsid=binfsid;
info.Tobs=Tsid; 
info.fr0bin=fr0bin; 
info.ext2bindown=ext2bindown;
info.ext2binup=ext2binup; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Put all the estimators in one struct
hvectors.hplusfft=hplusfft; 
hvectors.hcrossfft=hcrossfft;
hvectors.hplusfftshifted=hplusfftshifted;
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


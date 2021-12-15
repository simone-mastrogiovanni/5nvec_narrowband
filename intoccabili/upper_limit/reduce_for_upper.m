function reduce_for_upper(secondtime,selpath,timepath,name2,inmat,inseg,fcenter,dext2,sdindex_min,sdindex_max,cut_array,simwaves,step)
% USE IT ONLY FOR UPPER LIMIT COMPUTATION WHERE ONLY THE SIGNAL IS PRESENT
% This function compute the narrow-band searches analysis, it:
% - Select the interested data chunks
% - apply spin-down corrections
% - Call the function that compute the 5-vectors and Detection statistic
% - Do the previous steps for N different spin-donw corrections
%
% This version use a fake threshold to not eliminate data 
% Input arguments:
% secondtime: Reference time for the source
% selpath: Path of the main folder,usually the foldere where you are
%          working
% timepath: File with the barycentric corrected time vector
% name2:  Useful add to output name.
% inmat: mat file with the corrected and down-sampled time series (corresponding to a 
%        given spin-down value) to be analyzed and other quantities.
% fcenter: Central frequency from which explore put 0 if you want the
% central frequency
% dext2: frequency width you want to explore
% inseg: Science segments list with path
% sdindex_min: PUT ANY NUMBER YOU WANT, JUST A FOSSIL
% sdindex_max: PUT ANY NUMBER YOU WANT, JUST A FOSSIL
% cut_array: Array containing the days you want to analyze from the
% starting day of sbl (string)
% simwaves: Waves to inject with the parameters (Unitary Amplitude)
%   simwaves.eta=eta
%   simwaves.psi=psi (radiants)
%   simwaves.binfsid=frequency bin for the search
%   simwaves.step= Frequency Step at which repeat the injection  THE ONEPUT IN THE REAL ANALYSIS NOT APROXYMIZED(Hz)
%   simwaves.Npk= Number ok peaks to inject
%   simwaves.fstart= Frequency from which start to inject the signals AL
%   TEMPO DI RIFERIMTNO SECONDTIME
%   simwaves.sd= Spin-down (Hz/s) AL
%   TEMPO DI RIFERIMTNO SECONDTIME
%   simwaves.sdd= Second spin down (Hz/s2) AL
%   TEMPO DI RIFERIMTNO SECONDTIME
%   simwaves.sdindex=indice sd dal centrale
% step:Use it to divide the freq range in step sub-bands,for each save the
%      local maxima. Use 0 if you want the full analysis (string). IF YOU
%      ARE DOING UL PUT IT 0 FOR NO PROBLEMS
%
% Output:
% selection file: File containing the Science segments ( used to boost speed)
% templates file: File containing the freq components of template ( used to boost speed)
% [selpath,name2,filename]: File contaning the Results:
%  Sfft: Detection Statistic
%  Sfftshifted: Interpoleted detection statistic
%  fra: Frequency vector
%  hvectors: struct containing the estimators
%  info: Struct containg several info, like the freq.bin
%  gg_sc_clean: corrected time series


% Simone Mastrogiovanni 2015
% NB Check always the fact that the two interferometers starts at the same
% time and has the same number of down-sampled series--->freq bin coincides
% NB2 Reference time of sources MUST be the same for joint analysis




secondtime=str2double(secondtime);
cut_array=str2num(cut_array);
fcenter=str2double(fcenter);
dext2=str2double(dext2);
sdindex_min=str2double(sdindex_min);
sdindex_max=str2double(sdindex_max);

sdindex_min=0; % Needed for the rigth SD correction
sdindex_max=0; % Needed for the rigth SD correction

if exist('step','var')
    step=str2double(step); 
end

load(inmat,'in','ibias','ext1','ioutb','dtout','g','ioutin','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');

if secondtime==0
   secondtime=t0; 
    
end
%$ Load time vector for a given band 
if ~exist('gtime','var')
    load(timepath,'gtime','siout','g_p','g_tnot');

end
if (cut_array(1)~=0 & cut_array(2)~=0)
sourcestr=[sourcestr,'_days_',num2str(cut_array(1)),'-',num2str(cut_array(2))];
end


%integer part of the left extreme of the extracted band
freqint=ext1(1)-mod(ext1(1),round(1/dtout));

if ~exist('ioutin','var')
    ioutin=ioutout;
end
Diout=ioutin-ioutout;%correct for time shifts
%extract signal and time series

P=out;
igini=floor(round(1.0/dtout)*siout{1})+round(1.0/dtout)*ibias;
igfin=ioutb+length(P)-1; %$ AUTOCONSISTENTE CON PSS_1
gartime=gtime(igini:igfin);
gar_tnot=g_tnot(igini:igfin);
gar_p=g_p(igini:igfin);


if ~exist([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'file')
    
    gar=g(igini:igfin);
    iii=check_nan(gar,1);
    gar(iii)=0;
    gg=gd(gar);
    pars.t0=t0;
    
    
    T0=T0-Diout;%correct for shifts
    gg=edit_gd(gg,'ini',T0,'dx',dtout,'cont',pars);    
    % put to zero non-science data, gg no longer used
    [vsel tsel mask gg_sc]=sel_data(gg,inseg,0); 
    clear gg
    gg_sc=edit_gd(gg_sc,'x',gartime);
    save([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gg_sc');
end



clear g, clear P, clear out, clear outime, clear gtime, clear Ptime
clear gar 
clear iii


for count_sd=sdindex_min:1:sdindex_max


    if exist([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'file')
        
        load([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gg_sc');
        cont=cont_gd(gg_sc);
        [tephem f0ephem df0ephem ephyes]=read_ephem_file(cont.sour);
        shifted_source=use_ephem_file(ephyes,secondtime,cont.sour,tephem,f0ephem,df0ephem); % update rotational parameters
        fcenter=shifted_source.f0;
        clearvars shifted_source tephem f0ephem df0ephem ephyes cont
    end


% EXTRACT A CERTAIN TIME SPAN OF THE DATA ( IF NEEDED) %%%%%%%%%%%
if (cut_array(1)~=0 && cut_array(2)~=0)  
        [gg_sc,iselff]=extract_data_nb(gg_sc,cut_array(1),cut_array(2),dtout);
        gar_tnot=gar_tnot(iselff);
        gartime=gartime(iselff);
        gar_p=gar_p(iselff);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% $$$$$$$$$$$ TEST-BOX INJECT A FAKE SIGNAL $$$$$$$$$$$$$$$
cont=cont_gd(gg_sc);

if isfield(cont.sour,'ephfile')
   cont.sour=rmfield(cont.sour,'ephfile');
   cont.sour=rmfield(cont.sour,'ephstarttime');
   cont.sour=rmfield(cont.sour,'ephendtime');
end
cont.sour.d3f0=0;
cont.sour.d4f0=0;
cont.sour.d5f0=0;
cont.sour.d6f0=0;
cont.sour.d7f0=0;
cont.sour.d8f0=0;
cont.sour.d9f0=0;
cont.sour.d10f0=0;
cont.sour.d11f0=0;
cont.sour.d12f0=0;


tstarto=cont.t0;
izeross=find(gartime==0);
ifull=find(gartime~=0);
gartime=gartime-gartime(ifull(1))+dx_gd(gg_sc)*ifull(1);
%gar_tnot=gar_tnot-gar_tnot(ifull(1))+dx_gd(gg_sc)*ifull(1);
%gar_p=gar_p-gar_p(1);
%gar_ein=gartime-gar_tnot-gar_p;
%gar_ein=gar_ein-gar_ein(1);
tt=gartime-gar_p;
tt(izeross)=0;
tt=tt+(tstarto-secondtime)*86400;


clear gartime gar_tnot gar_ein


tt=tt.';


NS=length(tt)
%tt=(0:1:length(xxx)-1)*dtout; % Genera il segnale a partire dal tempo iniziale interferometro QUESTO E' t-t0 COME NEI PROGRAMMI VERI
%tt=tt+(tstarto-secondtime)*86400;
tt2=0.5*tt.^2;
tt3=(1/6)*tt.^3;

eta=simwaves.eta;
psi=simwaves.psi;
sim_binfsid=simwaves.binfsid;
sim_step=simwaves.step;
dfinj=floor(sim_step/sim_binfsid)*sim_binfsid;
Ninj=simwaves.Npk;
inj_fstart=simwaves.fstart;
inj_sd=simwaves.sd;
inj_sdd=simwaves.sdd;

cont.sour.f0=inj_fstart;
cont.sour.df0=inj_sd;
cont.df0=inj_sd;
cont.sour.ddf0=inj_sdd;
cont.sour.eta=eta;
cont.sour.psi=psi;

Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi))
Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi)) % Parametri fittizzi

cont.appf0=inj_fstart;

nsid=10000; % number of points at which the sidereal response will be computed
SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency
stsub=gmst(cont.t0)+dtout*(0:NS-1)*(86400/SD)/3600; % Risposte siderali dal tempo iniziale interferometro
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sida,sidb]=check_ps_lf(cont.sour,ant,nsid); % computation of the sidereal response



rHp=real(Hp);
iHp=imag(Hp);
rHc=real(Hc);
iHc=imag(Hc);


sid1=sida(isub);
sid2=sidb(isub);



f0=inj_fstart;

df0=inj_sd;

ddf0=inj_sdd;
cont.appf0=f0;
cont.df0=df0;
cont.sour.f0=f0;
cont.sour.df0=df0;
cont.sour.ddf0=ddf0;
cont.sour.fepoch=secondtime;
cont.sour.pepoch=secondtime;


f0=cont.sour.f0-floor(cont.sour.f0);
df0=cont.sour.df0;
ddf0=cont.sour.ddf0;

ph1=(f0*tt+df0*(tt2)+(ddf0)*(tt3))*2*pi;
ph1=mod(ph1,2*pi);
f0a=(f0+df0*tt+ddf0*tt2); 
ph2=f0a.*(gar_p.')*2*pi;  % Romer phase evolution
ph2=mod(ph2,2*pi);
ph=mod(ph1+ph2,2*pi);
ph=ph.';
K1=rHp*sid1+rHc*sid2;
K2=iHp*sid1+iHc*sid2;
F1=cos(ph);
F2=sin(ph);
simr=K1.*(F1.')-K2.*(F2.');
simi=K1.*(F2.')+K2.*(F1.');


gar=simr+1j*simi;



%%%%%%%%%%%%% BLOCK TO INJECT N SIGNAL AT A DISTANCE OF dfinj THE SAME TIME%%%%%%%%
suppA=1-exp(2*pi*1j*dfinj*(Ninj)*(tt+gar_p'));
suppB=1-exp(2*pi*1j*dfinj*(tt+gar_p'));
if dfinj==0
   suppA=ones(length(tt),1); 
   suppB=ones(length(tt),1); 
end
freq_fact=suppA./suppB;
torem=find(tt==0);
freq_fact(torem)=1; % Remove NaN components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gar=gar.*freq_fact;

% gar(1e3:8e3)=0;
% gar(1e5:2e5)=0;
% gar(3e5:3e5+1e3)=0;
% gar(1e6:2e6)=0;
% 
% tt(1e3:8e3)=0;
% tt(1e5:2e5)=0;
% tt(3e5:3e5+1e3)=0;
% tt(1e6:2e6)=0;
%tt=tt+gar_p.';

[tephem f0ephem df0ephem ephyes]=read_ephem_file(cont.sour);
s1s=use_ephem_file(ephyes,tstarto,cont.sour,tephem,f0ephem,df0ephem);
cont.sour=s1s;
cont.df0=cont.sour.df0;
cont.appf0=cont.sour.f0;


tt=tt+gar_p';
tt=tt+(secondtime-tstarto)*86400;
tt(izeross)=0;
gg_sc=edit_gd(gg_sc,'y',gar,'x',tt,'cont',cont);

% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


%$ UPDATE ROTATIONAL PARAMETER AND TIME AT A NEW REFERENCE TIME %%%%%
cont=cont_gd(gg_sc);
[tephem f0ephem df0ephem ephyes]=read_ephem_file(cont.sour);
shifted_source=use_ephem_file(ephyes,secondtime,cont.sour,tephem,f0ephem,df0ephem); % update rotational parameters  
cont.corrections_par=shifted_source;
cont.appf0=shifted_source.f0;
cont.df0=shifted_source.df0;
t0start=cont.t0;
gg_sc=edit_gd(gg_sc,'cont',cont); % Update the gd
gartime=x_gd(gg_sc);
%gartime=gartime-gartime(1);
%gartime=(0:1:length(gartime))*dtout;
gg_sc=edit_gd(gg_sc,'x',gartime);% Update the gd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


temp_cont=cont_gd(gg_sc);
temp_cont.shiftedtime=(temp_cont.t0-secondtime)*86400;
gg_sc=edit_gd(gg_sc,'cont',temp_cont);
%%%%%%%%% SHIFT time vector to the new reference time %%%%%%%%%%%%%%%%%
x_mid=x_gd(gg_sc);
izeros=find(x_mid==0);
x_mid=x_mid+(t0start-secondtime)*86400; % il tempo � t-t0start quindi per portarlo a norma devo fare t-t0start+t0start-secondtime
x_mid(izeros)=0;
gg_sc=edit_gd(gg_sc,'x',x_mid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


gg_sc_sd=simone_applies_spin_down_corrections(gg_sc,count_sd,dtout);  % Apply spin-down corrections
clear gg_sc


%%%%%%%%%%%%% BOX to replace the zeros in the time vector %%%%%%%%%%%%%%% 

% x_mid=x_gd(gg_sc_sd);
% x_support=(0:1:length(x_mid)-1)*dtout+x_mid(1)+(t0start-secondtime)*86400;
% izeros=find(x_mid==0);
% x_mid(izeros)=x_support(izeros);
% gg_sc_sd=edit_gd(gg_sc_sd,'x',x_mid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cdf=cont_gd(gg_sc_sd);
df0new=cdf.corrections_par.df0;

% defines the two extremes of the band to be studied
ext2(1)=fcenter-freqint-(dext2/2);
ext2(2)=fcenter-freqint+(dext2/2);

if ext2(1)<0
    ext2(1)=1e-5;
end
if ext2(2)>(1.0/dx_gd(gg_sc_sd))
    ext2(2)=(1.0/dx_gd(gg_sc_sd))-1e-5;
end
disp(sprintf('Band Analyzed: %f Hz -%f Hz \n',ext2(1),ext2(2)));
thr=1e20
disp(sprintf('Fake Threshold: %f \n',thr));

% calculates the detection statistic for all the frequecy bins.

clearvars -except gg_sc_sd secondtime cut_array fcenter dext2 t0 ext1 gg_sc source ant in ext2 freqint thr sourcestr selpath inmat inseg sdindex_min sdindex_max dec_index step count_sd name2 df0new timepath dtout freqint ant sourcestr source
if step~=0
    sourcestr=['divided_in_',num2str(step),'Hz_',sourcestr];
    
end

[Sfft Sfftshifted  hvectors fra  info gg_sc_clean]=narrow_pentav_for_upper(selpath,gg_sc_sd,source,ant,ext2,freqint,inseg,thr,sourcestr);

%%%%%%%%% SELECT THE LOCAL MAXIMA IN A GIVEN SUB-BAND BETWEEN THE INTERPOLATED HALF-BIN DS AND DS %%%%%%%%%%%%%%
if step~=0

 step=floor(step/info.binfsid)*info.binfsid % Rescale the sub-band length to match with the grid 
 step_len=round(step/info.binfsid);

% Select the maximum DS between the half-bin and the normal one%%%%%%%  
 is=find(Sfft>=Sfftshifted); 
 isf=find(Sfftshifted>Sfft);
 Sfull(is)=Sfft(is);
 Sfull(isf)=Sfftshifted(isf);
 frafull(is)=fra(is);
 frafull(isf)=fra(isf)+0.5*info.binfsid; % Find the frequency
 hvectorsfull.hplusfft(is)=hvectors.hplusfft(is);
 hvectorsfull.hcrossfft(is)=hvectors.hcrossfft(is);
 hvectorsfull.hplusfft(isf)=hvectors.hplusfftshifted(isf);
 hvectorsfull.hcrossfft(isf)=hvectors.hcrossfftshifted(isf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% Adapat the Array length to the frequency grid %%%%%%%%%%%%%%%%%%%%
 new_length=floor(length(Sfft)/step_len)*step_len;
 Sfull=Sfull(1:new_length);
 frafull=frafull(1:new_length);
 hvectorsfull.hplusfft=hvectorsfull.hplusfft(1:new_length);
 hvectorsfull.hcrossfft=hvectorsfull.hcrossfft(1:new_length);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 Sfull_m=reshape(Sfull,step_len,length(Sfull)/step_len);
 frafull_m=reshape(frafull,step_len,length(Sfull)/step_len);
 hvectorsfull_m.hplusfft=reshape(hvectorsfull.hplusfft,step_len,length(Sfull)/step_len);
 hvectorsfull_m.hcrossfft=reshape(hvectorsfull.hcrossfft,step_len,length(Sfull)/step_len);
 
 [nonmiservi,imax_reduce]=max(Sfull_m);
 
 r_Sfft=zeros(1,length(Sfull)/step_len);
 r_fra=zeros(1,length(Sfull)/step_len);
 r_hvectors.hplusfft=zeros(1,length(Sfull)/step_len);
 r_hvectors.hcrossfft=zeros(1,length(Sfull)/step_len);
 
 
 %%%%%%%%%% COMPOSE the vectors with the DS local maximum and their
 %%%%%%%%%% frequency compoentns%%%%%%%%%%%%%%%%%%
 for i=1:1:length(Sfull)/step_len
     r_Sfft(i)=Sfull_m(imax_reduce(i),i);
     r_fra(i)=frafull_m(imax_reduce(i),i);
     r_hvectors.hplusfft(i)=hvectorsfull_m.hplusfft(imax_reduce(i),i);
     r_hvectors.hcrossfft(i)=hvectorsfull_m.hcrossfft(imax_reduce(i),i);
     
     
 end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if step ~=0
%     div_s=floor(length(Sfft)/step); %$ DIVIDE CON LA LUNGHEZZA
%     for i=1:1:step-1
%         [masS,i1]=max(Sfft( (i-1)*div_s+1:i*div_s));
%         [masSshifted,i2]=max(Sfftshifted( (i-1)*div_s+1:i*div_s));
%         if masS>masSshifted 
%            is=i1;
%            is=is+(i-1)*div_s;
%            r_Sfft(i)=Sfft(is);
%            r_fra(i)=fra(is);
%            r_hvectors.hplusfft(i)=hvectors.hplusfft(is);
%            r_hvectors.hcrossfft(i)=hvectors.hcrossfft(is);
%         end
%         if masS<masSshifted            
%            is=i2;
%            is=is+(i-1)*div_s;
%            r_Sfft(i)=Sfftshifted(is);
%            r_fra(i)=fra(is)+0.5*info.binfsid;
%            r_hvectors.hplusfft(i)=hvectors.hplusfftshifted(is);
%            r_hvectors.hcrossfft(i)=hvectors.hcrossfftshifted(is);          
%         end
%         if masS==masSshifted && masS==0           
%            is=i2;
%            is=is+(i-1)*div_s;
%            r_Sfft(i)=Sfft(is);
%            r_fra(i)=fra(is);
%            r_hvectors.hplusfft(i)=hvectors.hplusfft(is);
%            r_hvectors.hcrossfft(i)=hvectors.hcrossfft(is);          
%         end
%     end
% 
%     i=step;
%       [masS,i1]=max(Sfft( (i-1)*div_s+1:i*div_s));
%       [masSshifted,i2]=max(Sfftshifted( (i-1)*div_s+1:i*div_s));
%       if masS>masSshifted
%          is=i1;
%          is=is+(i-1)*div_s;
%          r_Sfft(i)=Sfft(is);
%          r_fra(i)=fra(is);
%          r_hvectors.hplusfft(i)=hvectors.hplusfft(is);
%          r_hvectors.hcrossfft(i)=hvectors.hcrossfft(is);
%       end
%       if masS<masSshifted            
%          is=i2;
%          is=is+(i-1)*div_s;
%          r_Sfft(i)=Sfftshifted(is);
%          r_fra(i)=fra(is)+0.5*info.binfsid;
%          r_hvectors.hplusfft(i)=hvectors.hplusfftshifted(is);
%          r_hvectors.hcrossfft(i)=hvectors.hcrossfftshifted(is);          
%       end
%       if masS==masSshifted && masS==0           
%            is=i2;
%            is=is+(i-1)*div_s;
%            r_Sfft(i)=Sfft(is);
%            r_fra(i)=fra(is);
%            r_hvectors.hplusfft(i)=hvectors.hplusfft(is);
%            r_hvectors.hcrossfft(i)=hvectors.hcrossfft(is);          
%       end
% end


%%%%%%%%%%%%%%%%%%%%%% SAVE ALL THE RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear gg
info.df0new=df0new;
inout=in;
inout=rmfield(inout,'chunk0');
inout=rmfield(inout,'chunk1');
% saves new data in new file
filename=strcat(sourcestr,'data_part2_sd_index=',num2str(count_sd),'.mat');

if step ~=0
    save([selpath,name2,filename],'r_Sfft','r_hvectors','r_fra','info','count_sd')
end
if step==0
    save([selpath,name2,filename],'Sfft','Sfftshifted','hvectors','fra','info','count_sd','gg_sc_clean')
end

clearvars -except ext1 secondtime ant t0 timeshift_simo cut_array selpath inmat inseg sdindex_min sdindex_max dec_index step count_sd name2 fcenter dext2 sdstart timepath dtout freqint source sourcestr in
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

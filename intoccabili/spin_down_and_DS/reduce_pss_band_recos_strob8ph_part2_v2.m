function reduce_pss_band_recos_strob8ph_part2_v2(secondtime,selpath,timepath,name2,inmat,inseg,fcenter,dext2,sdindex_min,sdindex_max,cut_array,step,cycle)
% This function compute the narrow-band searches analysis, it:
% - Select the interested data chunks,i.e. data start from a given MJD to
% an end MJD.
% - apply spin-down corrections
% - Call the function that compute the 5-vectors and Detection statistic
% - Do the previous steps for N different spin-down corrections
%
% Input argument:
% secondtime: New reference time for the source in INTEGER MJD (common for both data-sets).
% selpath: Path of the main folder,usually the foldere where you are
%          working
% timepath: File with the barycentric corrected time vector
% name2:  Add a string to the output file name.
% inmat: mat file with the barycentric corrected and down-sampled time series to be analyzed (+other quantities).
% fcenter: Central search frequency, put =0 if you want the source freq to
% be the central
% dext2: frequency width you want to explore
% inseg: Science segments list with path
% sdindex_min:start spin-down bin (in unit of 1/Tobs^2) from the source
%             expected spin-down
% sdindex_max:end spin-down bin (in unit of 1/Tobs^2) from the source
%             expected spin-down
% cut_array: Array containing the days you want to analyze (in MJD INTEGER)
% step (Hz) :Use it to divide the freq range in sub-bands. For each sub-bands save the
%      detection statistic local maxima. Use 0 if you want the full analysis (string)
% cycle: put 1 if you want to mix data, put 0 if not
%
% Intermidiate Files:
% selection file: File containing the Science segments (used to boost speed)
% templates file: File containing the template's 5-vectors.(used to boost speed)
% Output:
% [selpath,name2,filename]: File contaning the Results:
%  Sfft: array of detection statistic
%  Sfftshifted: array of half-bin detection statistic
%  fra: Frequency vector corresponding to the detection statistic
%  hvectors: struct containing the estimators arrays (H+/Hx)
%  info: Struct containg several info, like the freq.bin
%  gg_sc_clean: corrected time series


% Simone Mastrogiovanni 2016
% NB Reference time of sources MUST be the same for joint analysis



% Convert input argoments from string to doule %%%%%%%%
cycle=str2double(cycle);
secondtime=str2double(secondtime);
cut_array=str2num(cut_array);
fcenter=str2double(fcenter);
dext2=str2double(dext2);
sdindex_min=str2double(sdindex_min);
sdindex_max=str2double(sdindex_max);
if exist('step','var')
    step=str2double(step); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(inmat,'in','ibias','ext1','ioutb','dtout','g','ioutin','t0','pars','ioutout','T0','P','out','source','ant','sourcestr');

if secondtime==0
   secondtime=t0; 
end
% Load time vector for a given band 
load(timepath,'gtime','siout');

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
igini=floor(round(1.0/dtout)*siout{1})+1+round(1.0/dtout)*ibias;
igfin=ioutb+length(P)-1; 
gartime=gtime(igini:igfin);

% If the science segments file does not exist it is created and saved
if ~exist([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'file')    
    gar=g(igini:igfin);
    iii=check_nan(gar,1);
    gar(iii)=0;
    gartime(iii)=0;
    gg=gd(gar);
    pars.t0=t0;  
    T0=T0-Diout;%correct for shifts
    gg=edit_gd(gg,'ini',T0,'dx',dtout,'cont',pars,'x',gartime);
    % put to zero non-science data, gg no longer used
    [vsel tsel mask gg_sc]=sel_data(gg,inseg,100); 
    clear gg
    %gg_sc=edit_gd(gg_sc,'x',gartime);
   
    %threshold for the final cleaning of the data
    thr=final_clean(gg_sc,1);
    disp(sprintf('Threshold: %f \n',thr));
    %thr=1e20 
    % remove outliers from the time series, gg_sc no longer used
    gg_sc=rough_clean(gg_sc,-thr,thr);
    save([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gg_sc');
end

clear g, clear P, clear out, clear outime, clear gtime, clear Ptime
clear gar
clear gartime
clear iii

% Loop on spin-down corrections %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for count_sd=sdindex_min:1:sdindex_max
    
    if exist([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'file')
        load([selpath,'selection_',num2str(ext1(1)),'_',num2str(ext1(2)),'.mat'],'gg_sc');
        if cycle~=0
            gg_sc=decoherence(gg_sc,cycle);
        end
    end
    
    
    % $$$$$$$$$$$ TEST-BOX INJECT A FAKE SIGNAL $$$$$$$$$$$$$$$
    % xxx=x_gd(gg_sc);
    % cont=cont_gd(gg_sc);
    % cont.t0
    % NS=length(xxx)
    % tt=(0:1:length(xxx)-1)*dtout; % Genera il segnale a partire dal tempo iniziale interferometro QUESTO E' t-t0 COME NEI PROGRAMMI VERI
    % tt2=0.5*tt.^2;
    % tt3=(1/6)*tt.^3;
    % eta=0.16
    % psi=25*pi/180
    % Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
    % Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi)); % Parametri fittizzi
    %
    % ant=virgo
    %
    % nsid=10000; % number of points at which the sidereal response will be computed
    % SD=86164.09053083288; %$ Sidereal day in seconds
    % FS=1/86164.09053083288; %$ Sidereal frequency
    % stsub=gmst(cont.t0)+dtout*(0:NS-1)*(86400/SD)/3600; % Risposte siderali dal tempo iniziale interferometro
    % isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
    % [~, ~, ~, ~, sida,sidb]=check_ps_lf(cont.sour,ant,nsid); % computation of the sidereal response
    %
    %
    % rHp=real(Hp);
    % iHp=imag(Hp);
    % rHc=real(Hc);
    % iHc=imag(Hc);
    %
    %
    % sid1=sida(isub);
    % sid2=sidb(isub);
    % f0=round((cont.appf0-floor(cont.appf0))/2.901440391067742e-07)*2.901440391067742e-07+0.5*2.901440391067742e-07
    %
    % df0=cont.df0
    % ddf0=cont.sour.ddf0
    % cont.sour.f0=f0+192
    % cont.sour.fepoch=secondtime
    % cont.sour.pepoch=secondtime
    % cont.appf0=f0+192
    %
    %
    % [tephem f0ephem df0ephem ephyes]=read_ephem_file(cont.sour);
    % s1s=use_ephem_file(ephyes,t0,cont.sour,tephem,f0ephem,df0ephem);
    % cont.sour=s1s;
    % f0=cont.sour.f0-192
    % df0=cont.sour.df0
    % ddf0=cont.sour.ddf0
    %
    % ph1=(f0*tt+df0*(tt2)+ddf0*(tt3))*2*pi;
    % ph=mod(ph1,2*pi);
    % ph=ph.';
    % K1=rHp*sid1+rHc*sid2;
    % K2=iHp*sid1+iHc*sid2;
    % F1=cos(ph);
    % F2=sin(ph);
    % simr=K1.*(F1.')-K2.*(F2.');
    % simi=K1.*(F2.')+K2.*(F1.');
    %
    %
    % gar=simr+1j*simi;
    % % gar(1e3:8e3)=0;
    % % gar(1e5:2e5)=0;
    % % gar(3e5:3e5+1e3)=0;
    % % gar(1e6:2e6)=0;
    % %
    % % tt(1e3:8e3)=0;
    % % tt(1e5:2e5)=0;
    % % tt(3e5:3e5+1e3)=0;
    % % tt(1e6:2e6)=0;
    %
    % gg_sc=edit_gd(gg_sc,'y',gar,'x',tt,'cont',cont);
    % $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
    
    %$ UPDATE ROTATIONAL PARAMETER AT A NEW REFERENCE TIME %%%%%
    cont=cont_gd(gg_sc);
    [tephem f0ephem df0ephem ephyes]=read_ephem_file(cont.sour);
    shifted_source=use_ephem_file(ephyes,secondtime,cont.sour,tephem,f0ephem,df0ephem); % update rotational parameters 
    cont.corrections_par=shifted_source;
    cont.appf0=shifted_source.f0;
    cont.df0=shifted_source.df0;
    t0start=cont.t0;
    gg_sc=edit_gd(gg_sc,'cont',cont); % Update the gd
    gartime=x_gd(gg_sc);
    %gartime=gartime-gartime(1); % Shift to the 0
    %gartime=(0:1:length(gartime))*dtout;
    gg_sc=edit_gd(gg_sc,'x',gartime);% Update the gd
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % EXTRACT A CERTAIN TIME SPAN OF THE DATA (IF NEEDED) %%%%%%%%%%%
    if (cut_array(1)~=0 && cut_array(2)~=0)
        gg_sc=extract_data_nb(gg_sc,cut_array(1),cut_array(2),dtout);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the time shift of the cut
    temp_cont=cont_gd(gg_sc);
    temp_cont.shiftedtime=(temp_cont.t0-secondtime)*86400;
    gg_sc=edit_gd(gg_sc,'cont',temp_cont);
    
    %%%%%%%%% SHIFT time vector to the new reference time %%%%%%%%%%%%%%%%%
    x_mid=x_gd(gg_sc);
    izeros=find(x_mid==0);
    x_mid=x_mid+(t0start-secondtime)*86400; % Shift the time vector in such a way that at the end is t-secondtime
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
    if fcenter==0
    fcenter=cdf.appf0
    end
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
    % calculates the detection statistic for all the frequecy bins.
    
    clearvars -except cycle gg_sc_sd secondtime cut_array fcenter dext2 t0 ext1 gg_sc source ant in ext2 freqint thr sourcestr selpath inmat inseg sdindex_min sdindex_max dec_index step count_sd name2 df0new timepath dtout freqint ant sourcestr source
    if step~=0
        sourcestr=['divided_in_',num2str(step),'Hz_',sourcestr];        
    end
    
    [Sfft Sfftshifted  hvectors fra  info gg_sc_clean]=narrow_pentav(selpath,gg_sc_sd,source,ant,ext2,freqint,sourcestr);
    
    %%%%%%%%% SELECT THE LOCAL MAXIMA IN A GIVEN SUB-BAND BETWEEN THE INTERPOLATED interbin DS AND DS %%%%%%%%%%%%%%
    if step~=0 % If requested
        
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
        
        
        %%%% Adapat the Array length in such a way that is an integer multiple of the sub-band %%%%%%%%%%%%%%%%%%%%
        new_length=floor(length(Sfft)/step_len)*step_len;
        Sfull=Sfull(1:new_length);
        frafull=frafull(1:new_length);
        hvectorsfull.hplusfft=hvectorsfull.hplusfft(1:new_length);
        hvectorsfull.hcrossfft=hvectorsfull.hcrossfft(1:new_length);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Reshape the arrays in a matrix form with each column corresponding to a
        % given  freq sub-band %
        Sfull_m=reshape(Sfull,step_len,length(Sfull)/step_len);
        frafull_m=reshape(frafull,step_len,length(Sfull)/step_len);
        hvectorsfull_m.hplusfft=reshape(hvectorsfull.hplusfft,step_len,length(Sfull)/step_len);
        hvectorsfull_m.hcrossfft=reshape(hvectorsfull.hcrossfft,step_len,length(Sfull)/step_len);
        
        [nonmiservi,imax_reduce]=max(Sfull_m);
        
        % Allocate memory for some arrays
        r_Sfft=zeros(1,length(Sfull)/step_len);
        r_fra=zeros(1,length(Sfull)/step_len);
        r_hvectors.hplusfft=zeros(1,length(Sfull)/step_len);
        r_hvectors.hcrossfft=zeros(1,length(Sfull)/step_len);
        
        
        %%%%%%%%%% Create the arrays with components corresponding to the
        %%%%%%%%%% maximum of the detection statistic in each sub-band%%%%%
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
        work_size=whos('gg_sc_clean'); % Check on the gg_sc_clean size, in case mustbe recomputed
        %if round(work_size.bytes/1e6)<100
        save([selpath,name2,filename],'Sfft','Sfftshifted','hvectors','fra','info','count_sd','gg_sc_clean')
        %else
        %save([selpath,name2,filename],'Sfft','Sfftshifted','hvectors','fra','info','count_sd')
        %end
    end
    
    clearvars -except cycle ext1 secondtime ant t0 timeshift_simo cut_array selpath inmat inseg sdindex_min sdindex_max dec_index step count_sd name2 fcenter dext2 sdstart timepath dtout freqint source sourcestr in
    close all
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

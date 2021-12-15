function [out_IFO,out_joint]=test_SNR_evolution(folding,gg,ant,sour,cut_array,SNR_test)
%
%This function compute the evolution of the coherence and parameters for
%different length of data chunks, needed for computation of SNR evolution

%     Input
%     %sour sorgente del candidato con parametri rotazionli
%     gg   cell of gd containing the candidate data chunk
%     ant cell of ant 
%     sour   source structure of the candidate
%     cut_array array with new start time and new end time (INTEGER MJD)
%     gg2 Possible coincidente candidate of another interferometr
%     SNR_test: put 1 if you want to compute SNR
%     peaks_5: 1 if you want 5 peaks plot, 0 if not
%
%
%     Output:
%      Parameters and coherence estimations
%       exit_cell{1}= [h0,eta,psi,phi0,cohe];
%       exit_cell{2}=data 5/10 vectors
%       out{3}=SNR
%       out{4}=Varianza
%       out{5}=Fraction of data samples

SD=86164.09053083288;
cand_freq=sour.f0;
number_of_IFO=length(gg);

for indx_ifo=1:1:number_of_IFO
    
    dtout=dx_gd(gg{indx_ifo});
    cand_freq=cand_freq-floor(cand_freq*dtout)/dtout % Compute the fractional of the frequency
    
    
    t_cont=cont_gd(gg{indx_ifo});
    t0start=t_cont.t0;
    tot_samples{indx_ifo}=length(y_gd(gg{indx_ifo}))-length(find(y_gd(gg{indx_ifo})==0));
    gg{indx_ifo}=extract_data_nb(gg{indx_ifo},cut_array(1),cut_array(2),dtout); % Taglia il data chunk e mette il nuovo temp inizio
    y_data_science{indx_ifo}=length(find(y_gd(gg{indx_ifo})~=0));
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the time shift of the cut
    temp_cont=cont_gd(gg{indx_ifo});
    temp_cont.shiftedtime=(temp_cont.t0-temp_cont.corrections_par.fepoch)*86400;
    gg{indx_ifo}=edit_gd(gg{indx_ifo},'cont',temp_cont);
    
    
    y=y_gd(gg{indx_ifo});
    NS=length(y);
    obs=find(y~=0); % array of 1s (when data sample is non-zero) and zeros
    
    clearvars y
    nsid=10000; % number of points at which the sidereal response will be computed
    
    cont=cont_gd(gg{indx_ifo});
    tempo=x_gd(gg{indx_ifo});
    tempo=tempo.';
    t0=cont.t0;
    ph0=mod(cand_freq*tempo,1)*2*pi;%$ Signal phase for template
    stsub=gmst(t0)+dtout*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
    isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
    [~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant{indx_ifo},nsid); % computation of the sidereal response
    Aplus=zeros(size(sid1(isub))); % + signal template
    Across=zeros(size(sid2(isub))); % x signal template
    Aplus(obs)=sid1(isub(obs));
    Across(obs)=sid2(isub(obs));
    Aplus(obs)=Aplus(obs).*exp(1j*ph0(obs)); % + signal template
    Across(obs)=Across(obs).*exp(1j*ph0(obs)); % x signal template
    gAp=gg{indx_ifo};
    gAc=gg{indx_ifo};
    gAp=edit_gd(gAp,'y',Aplus);
    gAc=edit_gd(gAc,'y',Across);
    
    if folding==1
        [gg{indx_ifo} weq]=tsid_equaliz_narrowband(gg{indx_ifo},1,ant{indx_ifo},sour.f0); % data folding
        [gAp weq0]=tsid_equaliz_narrowband(gAp,1,ant{indx_ifo},sour.f0); % signal + template folding
        [gAc weq45]=tsid_equaliz_narrowband(gAc,1,ant{indx_ifo},sour.f0); % signal x template folding
        
        % equalize
        gg{indx_ifo}=gg{indx_ifo}./weq;
        gAp=gAp./weq0;
        gAc=gAc./weq45;
        
        Ap_1=DFT_simo(gAp,0);
        Ac_1=DFT_simo(gAc,0);
        
        Ap_1=Ap_1.';
        Ac_1=Ac_1.';
        
        A0{indx_ifo}=Ap_1;
        A45{indx_ifo}=Ac_1;
    else
        
        Ap_1=DFT_simo(gAp,cand_freq);
        Ac_1=DFT_simo(gAc,cand_freq);
        
        Ap_1=Ap_1.';
        Ac_1=Ac_1.';
        
        A0{indx_ifo}=Ap_1;
        A45{indx_ifo}=Ac_1;
    end


end

if folding==1
    cand_freq=0.;
end

out_joint=coherence_simone(gg,cand_freq,A0,A45);

for indx_ifo=1:1:number_of_IFO
    out_IFO{indx_ifo}=coherence_simone({gg{indx_ifo}},cand_freq,{A0{indx_ifo}},{A45{indx_ifo}});
end

% Generate 5-vectors plot
% extracts data and times from the clean time series
N=length(y_gd(gg{1})); % number of samples
dt=dx_gd(gg{1});% sampling time
binf=1/(N*dt);

freq_off_band_meno=(1:1:50)*(-binf)+cand_freq-round(0.00011/binf)*binf;
freq_off_band_piu=(1:1:50)*binf+cand_freq+round(0.00011/binf)*binf;

if (SNR_test==1)
    
    for i=1:1:length(freq_off_band_meno)
        out_temp_joint=coherence_simone(gg,freq_off_band_meno(i),A0,A45);
        X_norm_m_joint(i)=out_temp_joint{1}(1);
        out_temp_joint=coherence_simone(gg,freq_off_band_piu(i),A0,A45);
        X_norm_p_joint(i)=out_temp_joint{1}(1);
        
        for indx_ifo=1:1:number_of_IFO
            out_temp_IFO{indx_ifo}=coherence_simone({gg{indx_ifo}},freq_off_band_meno(i),{A0{indx_ifo}},{A45{indx_ifo}});
            X_norm_m_IFO{indx_ifo}(i)=out_temp_IFO{indx_ifo}{1}(1);
            out_temp_IFO{indx_ifo}=coherence_simone({gg{indx_ifo}},freq_off_band_piu(i),{A0{indx_ifo}},{A45{indx_ifo}});
            X_norm_p_IFO{indx_ifo}(i)=out_temp_IFO{indx_ifo}{1}(1);
        end        
    end
    
    out_joint{3}=sqrt((norm(out_joint{1}(1))^2)/var([X_norm_m_joint,X_norm_p_joint]));
    out_joint{4}=var([X_norm_m_joint,X_norm_p_joint]);
    nump=0;
    numtot=0;
    for indx_ifo=1:1:number_of_IFO
        nump=nump+y_data_science{indx_ifo};
        numtot=numtot+tot_samples{indx_ifo};
    end
    out_joint{5}=nump/numtot; % Fraction of data samples
    
    for indx_ifo=1:1:number_of_IFO
        out_IFO{indx_ifo}{3}=sqrt((norm(out_IFO{indx_ifo}{1}(1))^2)/var([X_norm_p_IFO{indx_ifo},X_norm_m_IFO{indx_ifo}]));
        out_IFO{indx_ifo}{4}=var([X_norm_p_IFO{indx_ifo},X_norm_m_IFO{indx_ifo}]);
        out_IFO{indx_ifo}{5}=(y_data_science{indx_ifo})/(tot_samples{indx_ifo}); % Fraction of data samples
    end
    
end
close all





function X=DFT_simo(gg,freq)
FS=1/86164.09053083288; %$ Sidereal frequency
y=y_gd(gg);
y=y.';
freq=freq+(-2:1:2)*FS;
cont=cont_gd(gg);
shift=cont.shiftedtime;
dt=dx_gd(gg);
for i=1:1:5
    X(i)=sum(y.*exp(-1i*2*pi*freq(i)*dt*(0:length(y)-1))*dt);
    X(i)=X(i)*exp(-1j*2*pi*freq(i)*shift)/length(y);
end


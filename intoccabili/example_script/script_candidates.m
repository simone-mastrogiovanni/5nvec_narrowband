function [t_SNR_IFO,SNR_IFO,H0_IFO,cohe_IFO,Stat_IFO,t_SNR,SNR,H0,cohe,Stat]=script_candidates(gg,ant,sour,DT,folding)

% Use this script to perform the basic follow-ups procedures for the
% outliers in the narrow-band analysis

% INPUT:
% ggH= Input gd containing corrected time-series from narrow-band, I IFO
% ggL= Input gd containing corrected time-series from narrow-band, II IFO
% sour= source containg the parameters of the GW outlier/signal


%DT=[41;61;82;102;123;142;164;181;200]; % Insert the Time span from the initial time
%DT=[2,25;25,45;45,65;105,125;155,180;180,225]; % If you want to divide
size_DT=size(DT);


cont=cont_gd(gg{1});
tstart=round(cont.t0); % e sure to put the start time equal to the one in reduce script
% Compute the tests for the first Antenna

for i=1:1:size_DT(1)
    if size_DT(2)==1
        cut_array=[tstart tstart+DT(i)] % Time of integration
    else
        cut_array=[tstart+DT(i,1) tstart+DT(i,2)] % Time of integration
    end
    eval(['[out_IFO',num2str(tstart+DT(i)-tstart),'days,','out_joint',num2str(tstart+DT(i)-tstart),'days]','=test_SNR_evolution(',num2str(folding),',gg,ant,sour,cut_array,1);']);
end

SNR=eval(['out_joint',num2str(tstart+DT(1,1)-tstart),'days{3}']);
H0=eval(['out_joint',num2str(tstart+DT(1,1)-tstart),'days{1}(1)']);
Stat=eval(['out_joint',num2str(tstart+DT(1,1)-tstart),'days{1}(6)']);
cohe=eval(['out_joint',num2str(tstart+DT(1,1)-tstart),'days{1}(5)']);
t_SNR=eval(['out_joint',num2str(tstart+DT(1,1)-tstart),'days{5}']);

for i=2:1:size_DT(1)
    SNR=[SNR,eval(['out_joint',num2str(tstart+DT(i,1)-tstart),'days{3}'])];
    H0=[H0,eval(['out_joint',num2str(tstart+DT(i,1)-tstart),'days{1}(1)'])];
    Stat=[Stat,eval(['out_joint',num2str(tstart+DT(i,1)-tstart),'days{1}(6)'])];
    cohe=[cohe,eval(['out_joint',num2str(tstart+DT(i,1)-tstart),'days{1}(5)'])];
    t_SNR=[t_SNR,eval(['out_joint',num2str(tstart+DT(i,1)-tstart),'days{5}'])];
end

for indx_ifo=1:1:length(gg)
    SNR_IFO{indx_ifo}=eval(['out_IFO',num2str(tstart+DT(1,1)-tstart),'days{',num2str(indx_ifo),'}{3}']);
    H0_IFO{indx_ifo}=eval(['out_IFO',num2str(tstart+DT(1,1)-tstart),'days{',num2str(indx_ifo),'}{1}(1)']);
    Stat_IFO{indx_ifo}=eval(['out_IFO',num2str(tstart+DT(1,1)-tstart),'days{',num2str(indx_ifo),'}{1}(6)']);
    cohe_IFO{indx_ifo}=eval(['out_IFO',num2str(tstart+DT(1,1)-tstart),'days{',num2str(indx_ifo),'}{1}(5)']);
    t_SNR_IFO{indx_ifo}=eval(['out_IFO',num2str(tstart+DT(1,1)-tstart),'days{',num2str(indx_ifo),'}{5}']);
    
    for i=2:1:size_DT(1)
        SNR_IFO{indx_ifo}=[SNR_IFO{indx_ifo},eval(['out_IFO',num2str(tstart+DT(i,1)-tstart),'days{',num2str(indx_ifo),'}{3}'])];
        H0_IFO{indx_ifo}=[H0_IFO{indx_ifo},eval(['out_IFO',num2str(tstart+DT(i,1)-tstart),'days{',num2str(indx_ifo),'}{1}(1)'])];
        Stat_IFO{indx_ifo}=[Stat_IFO{indx_ifo},eval(['out_IFO',num2str(tstart+DT(i,1)-tstart),'days{',num2str(indx_ifo),'}{1}(6)'])];
        cohe_IFO{indx_ifo}=[cohe_IFO{indx_ifo},eval(['out_IFO',num2str(tstart+DT(i,1)-tstart),'days{',num2str(indx_ifo),'}{1}(5)'])];
        t_SNR_IFO{indx_ifo}=[t_SNR_IFO{indx_ifo},eval(['out_IFO',num2str(tstart+DT(i,1)-tstart),'days{',num2str(indx_ifo),'}{5}'])];
    end
    
end

if size_DT(2)~=1
    
    for indx_ifo=1:1:length(gg)
        
        t_SNR_IFO{indx_ifo}=1:1:size_DT(1)
    end
    t_SNR=1:1:size_DT(1);
end

end


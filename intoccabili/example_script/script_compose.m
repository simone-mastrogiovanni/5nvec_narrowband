% This script compose the detection statistic and estimators in just one file
% You will find the output in the workspace
% OUT in Workspace:
% 	r_Sfft: Maximum of the Sfft in any given sub-band over the spin-down
% 	r_fra: Frequency vector
% 	r_sd: Vector with the spin-down values
%       r_hvectors: Estimators struct
%       Sfft_lin: Complete DS over the parameter space
%	sd_lin: Complente sd_values over the parameter space
%	fra_lin: Complete freq array over the parameter spacw
%	hpfft_lin: Estimator + overthe parameter space
%	hcfft_lin: Estimator x over the parameter space

prefile='/Volumes/Simone_work/O2_narrowband/vela2/reduced/reduced_J0835m4510_J0835m4510_days_57758-57990data_part2_sd_index='; % Insert here the first part of the file
postfile='.mat'; % Insert here the second part of the file
minind=-17; % insert here the cycling indexes of the files
for i=minind:1:17 % remeber to change here the number of spin-donw
    name=[prefile,num2str(i),postfile]
    load(name);
    if exist('Sfft','var')
        Sfft_full(i-minind+1,:)=Sfft;
        Sfftshifted_full(i-minind+1,:)=Sfftshifted;
        fra_full(i-minind+1,:)=fra;
        sd_full(i-minind+1,:)=ones(1,length(Sfft))*info.df0new;
        count_sd_full(i-minind+1,:)=ones(1,length(Sfft))*count_sd;
        hpfft(i-minind+1,:)=hvectors.hplusfft;
        hcfft(i-minind+1,:)=hvectors.hcrossfft;
        hpfftshifted(i-minind+1,:)=hvectors.hplusfftshifted;
        hcfftshifted(i-minind+1,:)=hvectors.hcrossfftshifted;
    else
        Sfft_full(i-minind+1,:)=r_Sfft;
        fra_full(i-minind+1,:)=r_fra;
        sd_full(i-minind+1,:)=ones(1,length(r_Sfft))*info.df0new;
        count_sd_full(i-minind+1,:)=ones(1,length(r_Sfft))*count_sd;
        hpfft(i-minind+1,:)=r_hvectors.hplusfft;
        hcfft(i-minind+1,:)=r_hvectors.hcrossfft;
    end
end
dimen=size(Sfft_full);
if exist('Sfft','var')
    Sfft_lin=reshape(Sfft_full,1,dimen(1)*dimen(2));
    Sfftshifted_lin=reshape(Sfftshifted_full,1,dimen(1)*dimen(2));
    sd_lin=reshape(sd_full,1,dimen(1)*dimen(2));
    fra_lin=reshape(fra_full,1,dimen(1)*dimen(2));
    hpfft_lin=reshape(hpfft,1,dimen(1)*dimen(2));
    hpfftshifted_lin=reshape(hpfftshifted,1,dimen(1)*dimen(2));
    count_sd_lin=reshape(count_sd_full,1,dimen(1)*dimen(2));
    
    hcfftshifted_lin=reshape(hcfftshifted,1,dimen(1)*dimen(2));
    hcfft_lin=reshape(hcfft,1,dimen(1)*dimen(2));
else
    Sfft_lin=reshape(Sfft_full,1,dimen(1)*dimen(2));
    sd_lin=reshape(sd_full,1,dimen(1)*dimen(2));
    fra_lin=reshape(fra_full,1,dimen(1)*dimen(2));
    hpfft_lin=reshape(hpfft,1,dimen(1)*dimen(2));
    hcfft_lin=reshape(hcfft,1,dimen(1)*dimen(2));
    count_sd_lin=reshape(count_sd_full,1,dimen(1)*dimen(2));
    
end
if exist('Sfft','var')
    [ap,ii]=max(Sfft_full);
    [ap,ij]=max(Sfftshifted_full);
    if lenght(ii)~=1
        for i=1:1:length(ii)
            r_Sfft(i)=Sfft_full(ii(i),i);
            r_Sfftshifted(i)=Sfftshifted_full(ij(i),i);
            r_fra(i)=fra_full(ii(i),i);
            r_sd(i)=sd_full(ii(i),i);
            r_count_sd(i)=count_sd_full(ii(i),i);
            r_hvectors.hplusfft(i)=hpfft(ii(i),i);
            r_hvectors.hcrossfft(i)=hcfft(ii(i),i);
            r_hvectors.hplusfftshifted(i)=hpfftshifted(ij(i),i);
            r_hvectors.hcrossfftshifted(i)=hcfftshifted(ij(i),i);
        end
    else
        r_Sfft=Sfft_full;
        r_Sfftshifted=Sfftshifted_full;
        r_fra=fra_full;
        r_sd=sd_full;
        r_count_sd=count_sd_full;
        r_hvectors.hplusfft=hpfft;
        r_hvectors.hcrossfft=hcfft;
        r_hvectors.hplusfftshifted=hpfftshifted;
        r_hvectors.hcrossfftshifted=hcfftshifted;
    end
    
else
    [ap,ii]=max(Sfft_full);
    if length(ii)~=1
        for i=1:1:length(ii)
            r_Sfft(i)=Sfft_full(ii(i),i);
            r_fra(i)=fra_full(ii(i),i);
            r_sd(i)=sd_full(ii(i),i);
            r_count_sd(i)=count_sd_full(ii(i),i);
            r_hvectors.hplusfft(i)=hpfft(ii(i),i);
            r_hvectors.hcrossfft(i)=hcfft(ii(i),i);
        end
    else
        r_Sfft=Sfft_full;
        r_fra=fra_full;
        r_sd=sd_full;
        r_count_sd=count_sd_full;
        r_hvectors.hplusfft=hpfft;
        r_hvectors.hcrossfft=hcfft;
        
    end
end

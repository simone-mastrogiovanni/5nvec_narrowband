function [upperH0,real_fra]=upper_limit_final_form(wavefile,filename,uppercount,H0in,Hstep,fileA,prefile,postfile,prefilesd,postfilesd,dt,perc,S_pvalue)

% This function compute the upperlimit (changing the frequency compoentns amplitude )
% given N analyzed files containing fakes waves, work only with Narrow-band
% programs.
% 
% wavefile: file containing the injected waves
% filename: Name of the reduced file, must contain the variables r_*  that are the final variables of the real analysis
% uppercount: Number of the injected waves
% H0in: Initial amplitude injected ( Unit must be the same of data)
% Hstep: Ampitude step for the upper limit ( Unit must be the same of data)
% fileA: File containing the 5/10-vectors of sidereal responses ( REAL ANALYSIS)
% prefile: String containing the first part of the file's name containing the injected signal (REDUCED).
% postfile: String containing the second part of the file's name containing the injected signal (REDUCED).
% prefilesd: String containing the first part of the file's name containing the real analysis (NOT REDUCED).
% postfilesd: String containing the second part of the file's name containing the real analysis (NOT REDUCED).
% dt: sampling time
% perc: Percentage of the upper limit to take over
% S_pvalue: Detection statistic corresponding to 1% pvalue

% Output:
% upperH0: UL on amplitude
% fra_upper: Frequency vector
% sd_upper: Spin-down associated to the upperlimit-Just for tests
% info:  information structure

%%%% LOAD FILE WITH THE REAL ANALYSIS DS AND ESTIMATORS %%%%%
load(fileA);
load(wavefile);

Ap2=norm(pentaAplusfft)^2;
Ac2=norm(pentaAcrossfft)^2;
load(filename,'r_Sfft','r_fra','r_hvectors');
real_hvectors=r_hvectors;
real_S=r_Sfft;
real_fra=r_fra;
supera=0;
bandcount=length(r_Sfft);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% BUILD A MATRIX CONTAINING THE ESTIMATORS OF ALL THE INJECTED SIGNALS%
for i=1:1:uppercount % Load the files containing the fake waves
    sdindex(i)=injected_waves{i}.sdindex;
    toload=[prefile,num2str(i),postfile];
	load(toload,'r_hvectors','r_fra','info');
    fake_hp(i,:)=r_hvectors.hplusfft;
    fake_hc(i,:)=r_hvectors.hcrossfft;
    fake_fra(i,:)=r_fra;
    i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%% Sort the estimators matrix according to the spin-down index %%%%%%%%%%%%%%%
[sdindexsorted,isort]=sort(sdindex);

fake_hp(:,:)=fake_hp(isort,:);
fake_hc(:,:)=fake_hc(isort,:);
fake_fra(:,:)=fake_fra(isort,:); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%% Read the corresponding file of the real analysis to any given injected signal %%%%%%%%%
for i=1:1:length(sdindex)
   load([prefilesd,num2str(sdindexsorted(i)),postfilesd],'hvectors','fra','info')
   [fra_mid1,ia1,ib1]=intersect(floor(2.0005*fra/info.binfsid),floor(2.0005*fake_fra(i,:)/info.binfsid)); % Find the interested frequency bin in the real analysis
   [fra_mid2,ia2,ib1]=intersect(floor(2.0005*(fra+0.5*info.binfsid)/info.binfsid),floor(2.0005*fake_fra(i,:)/info.binfsid)); % Find the interested frequency bin in the real analysis
   suppfra=[fra_mid1,fra_mid2]*info.binfsid/2.0005;
   real_hp(i,:)=[hvectors.hplusfft(ia1).',hvectors.hplusfftshifted(ia2).']; % Compute a matrix containing the estimaros of the real analysis
   real_hc(i,:)=[hvectors.hcrossfft(ia1).',hvectors.hcrossfftshifted(ia2).'];
   
   [aaa,isort]=sort(suppfra); % Sort according to the frequency
   real_hp(i,:)=real_hp(i,isort);
   real_hc(i,:)=real_hc(i,isort);
   i
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%% COMPUTE THE UL changing the wave's ampitude%%%%%%%%%%%%%%%%%%%%
for i=1:1:bandcount % Ciclo sui bin in frequenza
    control=0;
    H0=H0in;
    while control==0 % Controllo per il 90%
        H0=H0+Hstep;
        hplusprova=real_hp(:,i)+(H0)*fake_hp(:,i);
        hcrossprova=real_hc(:,i)+(H0)*fake_hc(:,i);
        
        %hplusprova=real_hvectors.hplusfft(i)+(H0)*fake_hp(:,i);
        %hcrossprova=real_hvectors.hcrossfft(i)+(H0)*fake_hc(:,i);
        
        Sprova=(Ap2^2)*abs(hplusprova).^2+(Ac2^2)*abs(hcrossprova).^2;
        Sprova=Sprova*dt^4;
        if (real_S(i)>S_pvalue)
            ij=find(Sprova>=real_S(i));
            if length(ij)>=round(perc*uppercount)
                control=1;
            end
        end
        if (real_S(i)<=S_pvalue)
            ij=find(Sprova>=S_pvalue);
            if length(ij)>=round(perc*uppercount)
                control=1;
            end
        end
    end
    upperH0(i)=H0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

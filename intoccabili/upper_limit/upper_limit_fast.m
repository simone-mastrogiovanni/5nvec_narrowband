function [upperH0,fra_upper,sd_upper,info]=upper_limit_fast(prefile,postfile,uppercount,H0in,Hstep,fileA,dt,perc,mincount,maxcount)

% This function compute the preliminary upperlimit injecting the signal
% directly as 5-vector. It can do the upperlimits over N different spin-down corrections or just on one spin-down correction 
% prefile: Name of the reduced file (first part), must contain the variables r_*
% postfile: Second part of the name of the file. PUT THE ASSEMBLED FILE IF
% YOU WANT
% uppercount: Number of the injected waves
% H0in: Initial amplitude to inject ( Unit must be the same of data)
% Hstep: Ampitude step for the upper limit ( Unit must be the same of data)
% fileA: File containing the 5/10-vectors of sidereal responses
% dt: sampling time
% perc: Percentage of the upper limit to take over
% mincount: minimum spin-down correction to compute (don't put if you want
% the complete upperlimit)
% maxcount: maximum spin-down correction to compute (don't put if you want
% the complete upperlimit)
%
% Output:
% upperH0: UL on amplitude
% fra_upper: Frequency vector
% sd_upper: Spin-down associated to the upperlimit-Just for tests
% info:  information structure


load(fileA);
Ap2=norm(pentaAplusfft)^2;
Ac2=norm(pentaAcrossfft)^2;

 for j=1:1:uppercount % Ciclo sul numero di onde che inietto
                    eta=-1+rand*2; %$Genera parametri di onda casuali
                    psi=-pi/4+(pi/2)*rand;
                    %$ Qui ci moltiplico gia` la fase casuale
                    Hp(j)=(cos(2*psi)-1j*eta*sin(2*psi))/sqrt(1+eta^2);
                    Hc(j)=(sin(2*psi)+1j*eta*cos(2*psi))/sqrt(1+eta^2);
 end


 if exist('mincount','var')
    for j_name=mincount:1:maxcount
        filename=[prefile,num2str(j_name),postfile]
        load(filename,'r_Sfft','r_hvectors','r_fra','info','r_sd');
        bandcount=length(r_Sfft);
        for i=1:1:bandcount % Ciclo sui bin in frequenza
            control=0;
            H0=H0in;
            while control==0 % Controllo per il 90%
                H0=H0+Hstep;
                hplusprova=r_hvectors.hplusfft(i)+H0*Hp;
                hcrossprova=r_hvectors.hcrossfft(i)+H0*Hc;
                Sprova=(Ap2^2)*abs(hplusprova).^2+(Ac2^2)*abs(hcrossprova).^2;
                Sprova=Sprova*dt^4;
                isup=find(Sprova>r_Sfft(i));
                if length(isup)>round(perc*uppercount)
                    control=1;
                end
            end
            upperH0(j_name-mincount+1,i)=H0;
        end
        fra_upper(j_name-mincount+1,:)=r_fra;
        sd_upper(j_name-mincount+1,:)=info.df0new*ones(1,length(r_fra));
    end
else
    filename=[prefile,postfile]
    load(filename,'r_Sfft','r_hvectors','r_fra','info','r_sd');
    bandcount=length(r_Sfft);
    for i=1:1:bandcount % Ciclo sui bin in frequenza
        control=0;
        H0=H0in;
        while control==0 % Controllo per il 90%
           H0=H0+Hstep;
           hplusprova=r_hvectors.hplusfft(i)+H0*Hp;
           hcrossprova=r_hvectors.hcrossfft(i)+H0*Hc;
           Sprova=(Ap2^2)*abs(hplusprova).^2+(Ac2^2)*abs(hcrossprova).^2;
           Sprova=Sprova*dt^4;
           isup=find(Sprova>r_Sfft(i));
           if length(isup)>round(perc*uppercount)
                control=1;
           end
        end
        upperH0(i)=H0;
    end
    fra_upper=r_fra;
    sd_upper=r_sd;
    
end

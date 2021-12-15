function [out_cell_IFO, fup_pack_IFO, out_cell_joint,  fup_pack_joint]=test_injection_narrow_band(DT,folding,simwaves,gg_sc,gApH,gAcH,sour,ant,pentaAplusfft_anal,pentaAcrossfft_anal)
%folding 1 if you want folding 0 if not
%simwaves.eta, simwaves.h,simwaves.psi
%gg_sc cell array first gd from narrow-band search
%sour source with f0 and df0 from the candidate, for the rest source fro gd
%ant cell array first antenna


eta=simwaves.eta;
psi=simwaves.psi;
H0=simwaves.H0;

number_of_IFOs=length(gg_sc);

for indx_IFO=1:1:number_of_IFOs
    % extracts data and times from the clean time series
    
    ggH{indx_IFO}=gg_sc{indx_IFO};
    
    
    t=x_gd(ggH{indx_IFO});
    t=t.';
    dt=dx_gd(ggH{indx_IFO});% sampling time
    
    fr=sour.f0; % reference search frequency
    fr0=fr-floor(sour.f0*dt)/dt; % fractional part of the signal frequency
    
    % generate signal templates and compute corresponding 5-vects
    ph0=mod(fr0*t,1)*2*pi;%$ Signal phase for template
    
    Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
    Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));
    
    y_H=y_gd(gg_sc{indx_IFO});
    
    time_serie_H=H0*(Hp*y_gd(gApH{indx_IFO}).'+Hc*y_gd(gAcH{indx_IFO}).').*exp(1j*ph0);
    y_H=y_H+time_serie_H.';
    ggH{indx_IFO}=edit_gd(ggH{indx_IFO},'y',y_H);
    
    ggH_not{indx_IFO}=ggH{indx_IFO};
    
    if folding==1
        [ggH{indx_IFO}, weq]=tsid_equaliz_narrowband(ggH{indx_IFO},1,ant{indx_IFO},fr); % data folding
        
        % equalize
        ggH{indx_IFO}=ggH{indx_IFO}./weq;
        
        pentaAplusfft_IFO{indx_IFO}=pentaAplusfft_anal{indx_IFO}(1:5);
        pentaAcrossfft_IFO{indx_IFO}=pentaAcrossfft_anal{indx_IFO}(1:5);
        data5_vec_IFO{indx_IFO}=compute_5vect_simo(ggH{indx_IFO},0);
        
    else
        pentaAplusfft_IFO{indx_IFO}=pentaAplusfft_anal{indx_IFO}(1:5);
        pentaAcrossfft_IFO{indx_IFO}=pentaAcrossfft_anal{indx_IFO}(1:5);
        data5_vec_IFO{indx_IFO}=compute_5vect_simo(ggH{indx_IFO},fr0);
        
    end
    
end

[t_SNR_IFO,SNR_IFO,H0_IFO,cohe_IFO,Stat_IFO,t_SNR_joint,SNR_joint,H0_joint,cohe_joint,Stat_joint]=script_candidates(ggH_not,ant,sour,DT,folding);
fup_pack_IFO{1}=t_SNR_IFO;
fup_pack_IFO{2}=SNR_IFO;
fup_pack_IFO{3}=H0_IFO;
fup_pack_IFO{4}=cohe_IFO;
fup_pack_IFO{5}=Stat_IFO;


fup_pack_joint{1}=t_SNR_joint;
fup_pack_joint{2}=SNR_joint;
fup_pack_joint{3}=H0_joint;
fup_pack_joint{4}=cohe_joint;
fup_pack_joint{5}=Stat_joint;


data5_vec=data5_vec_IFO{1};
pentaAcrossfft=pentaAcrossfft_IFO{1};
pentaAplusfft=pentaAplusfft_IFO{1};

for indx_IFO=2:1:number_of_IFOs
    data5_vec=[data5_vec,data5_vec_IFO{indx_IFO}];
    pentaAcrossfft=[pentaAcrossfft;pentaAcrossfft_IFO{indx_IFO}];
    pentaAplusfft=[pentaAplusfft;pentaAplusfft_IFO{indx_IFO}];
end

Ap2=norm(pentaAplusfft)^2;
Ac2=norm(pentaAcrossfft)^2;
hp=conj(dot(data5_vec,pentaAplusfft)/Ap2);
hc=conj(dot(data5_vec,pentaAcrossfft)/Ac2);


H0_esti=sqrt(norm(hp)^2+norm(hc)^2); %Amplitude estimator eq.B1 of ref.2)
a=hp/H0_esti;
b=hc/H0_esti;
A=real(a*conj(b)); %(See Eq.B2 of ref.2: the division by H0_esti lacks there!)
B=imag(a*conj(b)); %(Eq.B2 of ref.2: the division by H0_esti lacks there!)
C=norm(a)^2-norm(b)^2; %(Eq.B3 of ref.2: the division by H0_esti lacks there!)
eta_esti=(-1+sqrt(1-4*B^2))/(2*B); %(Eta estimator Eq.B4 of ref.2)
cos4psi=C/sqrt((2*A)^2+C^2); %(Eq.B5 of ref.2)
sin4psi=2*A/sqrt((2*A)^2+C^2); %(Eq.B6 of ref.2)
psi_esti=(atan2(sin4psi,cos4psi)/4)*180/pi; %psi estimator
phi0_esti=angle(hp/(H0_esti*(cos(2*psi_esti*pi/180)-1j*eta_esti*sin(2*psi_esti*pi/180))/sqrt(1+eta_esti^2))); %(See Eq.32 of ref.1)
sig=hp*pentaAplusfft+hc*pentaAcrossfft; %Total signal estimated 5-vector (use estimated complex amplitudes)

[mf,cohe]=mfcohe_5vec(data5_vec,sig.'); %Call function to compute coherence
close all
out_cell_joint{1}(1)=H0_esti;
out_cell_joint{1}(2)=eta_esti;
out_cell_joint{1}(3)=psi_esti;
out_cell_joint{1}(4)=phi0_esti;
out_cell_joint{1}(5)=cohe;
out_cell_joint{1}(6)=norm(hp).^2*Ap2^4+norm(hc).^2*Ac2^4;

for indx_ifo=1:1:number_of_IFOs
    
    
    Ap2=norm(pentaAplusfft_IFO{indx_ifo})^2;
    Ac2=norm(pentaAcrossfft_IFO{indx_ifo})^2;
    hp=conj(dot(data5_vec_IFO{indx_ifo},pentaAplusfft_IFO{indx_ifo})/Ap2);
    hc=conj(dot(data5_vec_IFO{indx_ifo},pentaAcrossfft_IFO{indx_ifo})/Ac2);
    
    H0_esti=sqrt(norm(hp)^2+norm(hc)^2); %Amplitude estimator eq.B1 of ref.2)
    a=hp/H0_esti;
    b=hc/H0_esti;
    A=real(a*conj(b)); %(See Eq.B2 of ref.2: the division by H0_esti lacks there!)
    B=imag(a*conj(b)); %(Eq.B2 of ref.2: the division by H0_esti lacks there!)
    C=norm(a)^2-norm(b)^2; %(Eq.B3 of ref.2: the division by H0_esti lacks there!)
    eta_esti=(-1+sqrt(1-4*B^2))/(2*B); %(Eta estimator Eq.B4 of ref.2)
    cos4psi=C/sqrt((2*A)^2+C^2); %(Eq.B5 of ref.2)
    sin4psi=2*A/sqrt((2*A)^2+C^2); %(Eq.B6 of ref.2)
    psi_esti=(atan2(sin4psi,cos4psi)/4)*180/pi; %psi estimator
    phi0_esti=angle(hp/(H0_esti*(cos(2*psi_esti*pi/180)-1j*eta_esti*sin(2*psi_esti*pi/180))/sqrt(1+eta_esti^2))); %(See Eq.32 of ref.1)
    sig=hp*pentaAplusfft_IFO{indx_ifo}+hc*pentaAcrossfft_IFO{indx_ifo}; %Total signal estimated 5-vector (use estimated complex amplitudes)
    
    [mf,cohe]=mfcohe_5vec(data5_vec_IFO{indx_ifo},sig.'); %Call function to compute coherence
    close all
    out_cell_IFO{indx_ifo}{1}(1)=H0_esti;
    out_cell_IFO{indx_ifo}{1}(2)=eta_esti;
    out_cell_IFO{indx_ifo}{1}(3)=psi_esti;
    out_cell_IFO{indx_ifo}{1}(4)=phi0_esti;
    out_cell_IFO{indx_ifo}{1}(5)=cohe;
    out_cell_IFO{indx_ifo}{1}(6)=norm(hp).^2*Ap2^4+norm(hc).^2*Ac2^4;

    
end

fprintf('The fractional part of the frequency is %f \n',fr0);






function X=compute_5vect_simo(gg,freq)

FS=1/86164.09053083288; %$ Sidereal frequency
penta_f=(-2:1:2)*FS+freq;
y=y_gd(gg);
y=y.';
cont=cont_gd(gg);
shift=cont.shiftedtime;
dt=dx_gd(gg);
for i=1:1:5
    X(i)=sum(y.*exp(-1j*2*pi*penta_f(i)*dt*(0:length(y)-1))*dt);
    X(i)=X(i)*exp(-1j*2*pi*penta_f(i)*shift)/length(y);
end
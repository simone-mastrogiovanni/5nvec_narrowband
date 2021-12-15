function [S,hp,hc,pentaAplusfft,pentaAcrossfft,data_5_vec_out,ggH,gApH,gAcH]=test_injection_narrow_band_true_signal(folding,gg_sc,sour,ant)
% 1 if you want folding 0 if not
%gg_sc  cell array of gds from narrow-band search
%sour source with f0 and df0 from the candidate, for the rest source fro gd
%ant cell array of antennas
%gg_sc2 second gd
%ant2 second antenna

% extracts data and times from the clean time series
number_IFO=length(gg_sc);
for indx_IFO=1:1:number_IFO
    
    ggH{indx_IFO}=gg_sc{indx_IFO};
    y=y_gd(ggH{indx_IFO});
    t=x_gd(ggH{indx_IFO});
    t=t.';
    NS=length(y); % number of samples
    dt=dx_gd(ggH{indx_IFO});% sampling time
    nsid=10000; % number of points at which the sidereal response will be computed
    SD=86164.09053083288; %$ Sidereal day in seconds
    
    cont=cont_gd(ggH{indx_IFO}); % input data cont structure
    t0=cont.t0; % Start time of data
    fr=sour.f0; % reference search frequency
    fr0=fr-floor(sour.f0*dt)/dt; % fractional part of the signal frequency
    obs=find(y~=0); % array of 1s (when data sample is non-zero) and zeros
    
    % generate signal templates and compute corresponding 5-vects
    ph0=mod(fr0*t,1)*2*pi;%$ Signal phase for template
    stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
    isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
    [~, ~, ~, ~, sid1,sid2]=check_ps_lf(sour,ant{indx_IFO},nsid); % computation of the sidereal response
    Aplus=zeros(size(sid1(isub))); % + signal template
    Across=zeros(size(sid2(isub))); % x signal template
    Aplus(obs)=sid1(isub(obs));
    Across(obs)=sid2(isub(obs));
    %Aplus(obs)=Aplus(obs).*exp(1j*ph0(obs)); % + signal template
    %Across(obs)=Across(obs).*exp(1j*ph0(obs)); % x signal template
    
    gAp{indx_IFO}=ggH{indx_IFO};
    gAc{indx_IFO}=ggH{indx_IFO};
    
    gAp{indx_IFO}=edit_gd(gAp{indx_IFO},'y',Aplus);
    gAc{indx_IFO}=edit_gd(gAc{indx_IFO},'y',Across);
    gApH{indx_IFO}=gAp{indx_IFO};
    gAcH{indx_IFO}=gAc{indx_IFO};
    
    
    if folding==1
        [ggH{indx_IFO} weq]=tsid_equaliz_narrowband(ggH{indx_IFO},1,ant{indx_IFO},fr); % data folding
        [gAp{indx_IFO} weq0]=tsid_equaliz_narrowband(gAp{indx_IFO},1,ant{indx_IFO},0); % signal + template folding
        [gAc{indx_IFO} weq45]=tsid_equaliz_narrowband(gAc{indx_IFO},1,ant{indx_IFO},0); % signal x template folding
        % equalize
        ggH{indx_IFO}=ggH{indx_IFO}./weq;
        gAp{indx_IFO}=gAp{indx_IFO}./weq0;
        gAc{indx_IFO}=gAc{indx_IFO}./weq45;
        pentaAplusfft{indx_IFO}=compute_5vect_simo(gAp{indx_IFO},0);
        pentaAcrossfft{indx_IFO}=compute_5vect_simo(gAc{indx_IFO},0);
        data5_vec{indx_IFO}=compute_5vect_simo(ggH{indx_IFO},0);
    else
        pentaAplusfft{indx_IFO}=compute_5vect_simo(gAp{indx_IFO},0);
        pentaAcrossfft{indx_IFO}=compute_5vect_simo(gAc{indx_IFO},0);
        data5_vec{indx_IFO}=compute_5vect_simo(ggH{indx_IFO},fr0);
    end
end

data_5_vec_out=data5_vec{1};
pentaAcrossfft_out=pentaAcrossfft{1};
pentaAplusfft_out=pentaAplusfft{1};

for indx_IFO=2:1:number_IFO
    data_5_vec_out=[data_5_vec_out,data5_vec{indx_IFO}];
    pentaAcrossfft_out=[pentaAcrossfft_out,pentaAcrossfft{indx_IFO}];
    pentaAplusfft_out=[pentaAplusfft_out,pentaAplusfft{indx_IFO}];
end

Ap2=norm(pentaAplusfft_out)^2;
Ac2=norm(pentaAcrossfft_out)^2;

hp=conj(dot(data_5_vec_out,pentaAplusfft_out))/Ap2;
hc=conj(dot(data_5_vec_out,pentaAcrossfft_out))/Ac2;

S=(Ap2^2)*norm(hp)^2+(Ac2^2)*norm(hc)^2;
fprintf('The fractional part of the frequency is %f \n',fr0);
end




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
end

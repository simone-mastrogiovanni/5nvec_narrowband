function [S,Hp,Hc,h0,eta,psi,phi0,Ap_5vec,Ac_5vec,Ap_5vec_2,Ac_5vec_2]=compute_DS_from_BSD_gd(gg,ant,sour,sample_freq,gg2,ant2)

% Compute the detection statistic and estimate the parameters for a general
% input GD.
% Input:
% gg   gd containing the time sereies (doppler and spin-down corrected)
% ant  antenna structure
% sour source structure
% sample_freq time series's sample frequency
% gg2 second IFO gd
% ant2 second IFO 
% Output:
% S   Detection statistic
% Hp   Estimator of the + polarisation
% Hc   Estimator of the X polarisation

SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency

if ~exist('gg2','var')

cont=cont_gd(gg); % input data cont structure
dt=dx_gd(gg);
y=y_gd(gg);
NS=length(y);

clear y

t0=cont.t0; % Start time of data
fr=sour.f0; % reference search frequency
fr0=fr-floor(fr/sample_freq)*sample_freq; % fractional part of the signal frequency

disp(sprintf('Fractional part of the frequency = %d',fr0));
if ~exist('template_5_vectors.mat','file');
obs=check_nonzero(gg,1); % array of 1s (when data sample is non-zero) and zeros
nsid=10000;
% generate signal templates and compute corresponding 5-vects
ph0=mod(fr0*dt*(0:NS-1),1)*2*pi;%$ Signal phase for template
stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response
Aplus=sid1(isub).*exp(1j*ph0); % + signal template
Across=sid2(isub).*exp(1j*ph0); % x signal template
Aplus=Aplus.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data
Across=Across.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data


Ap_gd=gg;
Ap_gd=edit_gd(Ap_gd,'y',Aplus);

Ap_5vec=compute_5vect_simo(Ap_gd,fr0);

Ac_gd=gg;
Ac_gd=edit_gd(Ac_gd,'y',Across);

Ac_5vec=compute_5vect_simo(Ac_gd,fr0);

save('template_5_vectors_1.mat','Ac_5vec','Ap_5vec');
end
load('template_5_vectors_1.mat','Ac_5vec','Ap_5vec');

data5vec=compute_5vect_simo(gg,fr0);
% figure;plot((0:1:length(y)-1)*(1/(length(y)*0.1)),abs(fft(y)*0.1));
% hold on
% plot(fr0-2/86164.09053083288,abs(data5vec(1)),'gp');
% plot(fr0-1/86164.09053083288,abs(data5vec(2)),'gp');
% plot(fr0-0/86164.09053083288,abs(data5vec(3)),'gp');
% plot(fr0+1/86164.09053083288,abs(data5vec(4)),'gp');
% plot(fr0+2/86164.09053083288,abs(data5vec(5)),'gp');
% 
% hold off


Hp=data5vec*Ap_5vec'/norm(Ap_5vec)^2;
Hc=data5vec*Ac_5vec'/norm(Ac_5vec)^2;



S=(norm(Ap_5vec)^4)*norm(Hp)^2+(norm(Ac_5vec)^4)*norm(Hc)^2;

[h0 eta psi phi0]=esti_io(Hp,Hc);

disp(sprintf('******Parameter Estimation****** \n H0= %d \t eta=%d \t psi=%d \t phi=%d',h0,eta,psi,phi0));

end

if exist('gg2','var')

cont=cont_gd(gg); % input data cont structure
dt=dx_gd(gg);
y=y_gd(gg);
NS=length(y);

clear y

t0=cont.t0; % Start time of data
fr=sour.f0; % reference search frequency
fr0=fr-floor(fr/sample_freq)*sample_freq; % fractional part of the signal frequency

disp(sprintf('Fractional part of the frequency = %d',fr0));
delete('template_5_vectors.mat'); % TOGLIERE SE REPUTI GIUSTO ALLA FINE
if ~exist('template_5_vectors.mat','file');
obs=check_nonzero(gg,1); % array of 1s (when data sample is non-zero) and zeros
nsid=10000;
% generate signal templates and compute corresponding 5-vects
ph0=mod(fr0*dt*(0:NS-1),1)*2*pi;%$ Signal phase for template
stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response
Aplus=sid1(isub).*exp(1j*ph0); % + signal template
Across=sid2(isub).*exp(1j*ph0); % x signal template
Aplus=Aplus.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data
Across=Across.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data


Ap_gd=gg;
Ap_gd=edit_gd(Ap_gd,'y',Aplus);

Ap_5vec=compute_5vect_simo(Ap_gd,fr0);

Ac_gd=gg;
Ac_gd=edit_gd(Ac_gd,'y',Across);

Ac_5vec=compute_5vect_simo(Ac_gd,fr0);


obs=check_nonzero(gg2,1); % array of 1s (when data sample is non-zero) and zeros
nsid=10000;
% generate signal templates and compute corresponding 5-vects
ph0=mod(fr0*dt*(0:NS-1),1)*2*pi;%$ Signal phase for template
stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant2,nsid); % computation of the sidereal response
Aplus=sid1(isub).*exp(1j*ph0); % + signal template
Across=sid2(isub).*exp(1j*ph0); % x signal template
Aplus=Aplus.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data
Across=Across.*obs'; %$ Put to zero in the templates the samples corresponding to zero in the data


Ap_gd=gg;
Ap_gd=edit_gd(Ap_gd,'y',Aplus);

Ap_5vec_2=compute_5vect_simo(Ap_gd,fr0);

Ac_gd=gg;
Ac_gd=edit_gd(Ac_gd,'y',Across);

Ac_5vec_2=compute_5vect_simo(Ac_gd,fr0);



save('template_5_vectors.mat','Ac_5vec','Ap_5vec','Ac_5vec_2','Ap_5vec_2');

end
load('template_5_vectors.mat','Ac_5vec','Ap_5vec','Ac_5vec_2','Ap_5vec_2');

data5vec=compute_5vect_simo(gg,fr0);
data5vec_2=compute_5vect_simo(gg2,fr0);


data5vec_tot=[data5vec,data5vec_2];
Ac_5vec_tot=[Ac_5vec,Ac_5vec_2];
Ap_5vec_tot=[Ap_5vec,Ap_5vec_2];

% figure;plot((0:1:length(y)-1)*(1/(length(y)*0.1)),abs(fft(y)*0.1));
% hold on
% plot(fr0-2/86164.09053083288,abs(data5vec(1)),'gp');
% plot(fr0-1/86164.09053083288,abs(data5vec(2)),'gp');
% plot(fr0-0/86164.09053083288,abs(data5vec(3)),'gp');
% plot(fr0+1/86164.09053083288,abs(data5vec(4)),'gp');
% plot(fr0+2/86164.09053083288,abs(data5vec(5)),'gp');
% 
% hold off


Hp=data5vec_tot*Ap_5vec_tot'/norm(Ap_5vec_tot)^2;
Hc=data5vec_tot*Ac_5vec_tot'/norm(Ac_5vec_tot)^2;



S=(norm(Ap_5vec_tot)^4)*norm(Hp)^2+(norm(Ac_5vec_tot)^4)*norm(Hc)^2;

[h0 eta psi phi0]=esti_io(Hp,Hc);

disp(sprintf('******Parameter Estimation****** \n H0= %d \t eta=%d \t psi=%d \t phi=%d',h0,eta,psi,phi0));

end






function X=compute_5vect_simo(gg,freq)

SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency
penta_f=(-2:1:2)*FS+freq;
y=y_gd(gg);
y=y.';
dt=dx_gd(gg);
for i=1:1:5
    
   X(i)=sum(y.*exp(-1i*2*pi*penta_f(i)*dt*(0:length(y)-1)))*dt; 
end

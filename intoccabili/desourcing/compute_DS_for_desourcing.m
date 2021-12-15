function [S,Hp,Hc,h0,eta,psi,phi0]=compute_DS_for_desourcing(gg,ant,sour,sample_freq,Ap_5vec,Ac_5vec,gg2,ant2,Ap_5vec_2,Ac_5vec_2)

% This function compute the Detection statistic and parameter estimation
% for the "desourcing" tests. 
%
% Input:
% gg   gd containing the time sereies (doppler and spin-down corrected)
% ant  antenna structure
% sour source structure
% sample_freq time series's sample frequency
% Ap_5vec 5- freq components of the sideareal response + polarisation
% Ac_5vec 5- freq components of the sidereal response x polarisarion
% gg2 second IFO gd
% ant2 second IFO 
% Ap_5vec_2 5- freq components of the sideareal response + polarisation II
% IFO
% Ac_5vec_2 5- freq components of the sidereal response x polarisarion II
% IFO
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

data5vec=compute_5vect_simo(gg,fr0);
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


data5vec=compute_5vect_simo(gg,fr0);
data5vec_2=compute_5vect_simo(gg2,fr0);


data5vec_tot=[data5vec,data5vec_2];
Ac_5vec_tot=[Ac_5vec,Ac_5vec_2];
Ap_5vec_tot=[Ap_5vec,Ap_5vec_2];
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

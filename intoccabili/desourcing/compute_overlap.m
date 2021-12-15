function [overlap, AA, DD]=compute_overlap(sour,ant,time,reftime,px,py,pz,alfa_des,delta_des,alfa_res,delta_res)
%[overlap_6m,AA,DD]=compute_overlap(source,ligoh,doptabs.ligoh(ii,1)*86400,doptabs.ligoh(ii(1),1)*86400,doptabs.ligoh(ii,2),doptabs.ligoh(ii,3),doptabs.ligoh(ii,4),1e-3,1e-3,1e-5,1e-5);
%gij=compute_metric_for_desourcing(source.f0,source.df0,source.a*pi/180,source.d*pi/180,doptabs.ligoh(ii,1)*86400,doptabs.ligoh(ii(1),1)*86400,doptabs.ligoh(ii,2),doptabs.ligoh(ii,3),doptabs.ligoh(ii,4))
f0=sour.f0;
f0dot=sour.df0;
alfa=sour.a*pi/180;
delta=sour.d*pi/180;
time_s=time-reftime;

dt=mean(diff(time_s));
fd=f0-floor(f0*dt)/dt;
eta=0.1600;
psi=25.4390*pi/180;
Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi)); % Parametri fittizzi

ph_signal=fd*time_s+0.5*f0dot*time_s.^2+(f0+f0dot*time_s).*(px*cos(alfa)*cos(delta)+py*sin(alfa)*cos(delta)+pz*sin(delta));
ph_signal=ph_signal*2*pi;
SD=86164.09053083288; %$ Sidereal day in seconds
NS=length(ph_signal);
t0=reftime;
nsid=1e5;
stsub=gmst(t0)+dt*(0:NS-1)*(86400/SD)/3600; % running Greenwich mean sidereal time
isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
[~, ~, ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response
Aplus_signal=(sid1(isub).').*exp(1j*ph_signal); % + signal template
Across_signal=(sid2(isub).').*exp(1j*ph_signal); % x signal template
signal=Hp*Aplus_signal+Hc*Across_signal+(randn(size(Aplus_signal))+1j*randn(size(Aplus_signal)))*sqrt(1/140);
Fstat_signal=(dot(signal,Aplus_signal)/dot(Aplus_signal,Aplus_signal))*dot(Aplus_signal,signal)+(dot(signal,Across_signal)/dot(Across_signal,Across_signal))*dot(Across_signal,signal);
Fstat_signal=abs(Fstat_signal);


alfa_v=alfa+(-round(alfa_des/alfa_res):1:round(alfa_des/alfa_res))*alfa_res;
delta_v=delta+(-round(delta_des/delta_res):1:round(delta_des/delta_res))*delta_res;
[AA,DD]=meshgrid(alfa_v,delta_v);
sizes=size(AA);

for i=1:1:sizes(1)*sizes(2)
    ph_template=fd*time_s+0.5*f0dot*time_s.^2+(f0+f0dot*time_s).*(px*cos(AA(i))*cos(DD(i))+py*sin(AA(i))*cos(DD(i))+pz*sin(DD(i)));
    ph_template=ph_template*2*pi;
    Aplus_template=(sid1(isub).').*exp(1j*ph_template); % + signal template
    Across_template=(sid2(isub).').*exp(1j*ph_template); % x signal template
    template=Aplus_template+Across_template;
    F_stat_noise=(dot(signal,Aplus_template)/dot(Aplus_template,Aplus_template))*dot(Aplus_template,signal)+(dot(signal,Across_template)/dot(Across_template,Across_template))*dot(Across_template,signal);
F_stat_noise=abs(F_stat_noise);

    
    overlap(i)=abs(dot(template,signal)/sqrt(dot(template,template)*dot(signal,signal)));
    %overlap(i)=(F_stat_noise-Fstat_signal)/Fstat_signal;
end

overlap=reshape(overlap,sizes(1),sizes(2));

end
function out_cell=coherence_simone(gg,freq,A0_cell,A45_cell)
% This function uses 5-vectors to make parameter estimation and the
% coherence
%
% Input:
%   gg:      cell array with ggs
%   fr:     frequency of the signal ( fractional part)
%   A0:     cell array with + signal 5-vectoror 10-vector (no PSD weight)
%   A45:    cell array with X signal 5-vectoror 10-vector (no PSD weight)
% Output:
%      Parameters and coherence estimations
% exit_cell{1}= [h0,eta,psi,phi0,cohe] Parameters
% exit_cell{2}=data 5n vectors

% matched filters to estimate complex amplitudes (Eq. 19,20 of ref.2)

number_of_IFOs=length(gg);

for indx_gd=1:1:length(gg)
    gg_permed=decoherence(gg{indx_gd},1);
    spectrum_esti=gd_pows(gg_permed,'pieces',100);
    rel_weights(indx_gd)=1.0/mean(spectrum_esti);
end
rel_weights=rel_weights/mean(rel_weights);


X=compute_5vect_simo(gg{1},freq)*sqrt(rel_weights(1));
A0=A0_cell{1}*sqrt(rel_weights(1));
A45=A45_cell{1}*sqrt(rel_weights(1));



for indx_ifo=2:1:number_of_IFOs
    
    X=[X,compute_5vect_simo(gg{indx_ifo},freq)*sqrt(rel_weights(indx_ifo))];
    A0=[A0;A0_cell{indx_ifo}*sqrt(rel_weights(indx_ifo))];
    A45=[A45;A45_cell{indx_ifo}*sqrt(rel_weights(indx_ifo))];
end

A0=A0.';
A45=A45.';
mf0=conj(A0)./norm(A0).^2;
mf45=conj(A45)./norm(A45).^2;
hp=sum(X.*mf0);
hc=sum(X.*mf45);

h0=sqrt(norm(hp)^2+norm(hc)^2); %Amplitude estimator eq.B1 of ref.2)

a=hp/h0;
b=hc/h0;

A=real(a*conj(b)); %(See Eq.B2 of ref.2: the division by h0 lacks there!)
B=imag(a*conj(b)); %(Eq.B2 of ref.2: the division by h0 lacks there!)
C=norm(a)^2-norm(b)^2; %(Eq.B3 of ref.2: the division by h0 lacks there!)

eta=(-1+sqrt(1-4*B^2))/(2*B); %(Eta estimator Eq.B4 of ref.2)
cos4psi=C/sqrt((2*A)^2+C^2); %(Eq.B5 of ref.2)
sin4psi=2*A/sqrt((2*A)^2+C^2); %(Eq.B6 of ref.2)
psi=(atan2(sin4psi,cos4psi)/4)*180/pi; %psi estimator
phi0=angle(hp/(h0*(cos(2*psi*pi/180)-1j*eta*sin(2*psi*pi/180))/sqrt(1+eta^2))); %(See Eq.32 of ref.1)

sig=hp*A0+hc*A45; %Total signal estimated 5-vector (use estimated complex amplitudes)
[mf,cohe]=mfcohe_5vec(X,sig); %Call function to compute coherence
Stat = norm(hp).^2*norm(A0).^4+norm(hc).^2*norm(A45).^4;
out_cell{1}=[h0,eta,psi,phi0,cohe,Stat];
out_cell{2}=X;

function X=compute_5vect_simo(gg,freq)

SD=86164.09053083288; %$ Sidereal day in seconds
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



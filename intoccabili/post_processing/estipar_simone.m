function [h0 eta psi cohe phi0]=estipar(X,A0,A45)
% This function uses 5-vectors to make parameter estimation and the
% coherence
%
% Input:
%   X:      data 5-vector
%   A0:     + signal 5-vector
%   A45:    x signal 5-vector
%
% Output:
%      Parameters and coherence estimations

% matched filters to estimate complex amplitudes (Eq. 19,20 of ref.2)
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
[mf cohe]=mfcohe_5vec(X,sig); %Call function to compute coherence
function [eta psi amp2 a b]=par4dof_5meth(X,L0,L45)
% par4dof_3meth  computes parameters from data with 3 methods
%                The 5 methods are:
%                - empirical method (maximum content)
%                - full map
%                - analytic maximum
%                - full map (circ pol)
%                - analytic maximum (circ pol)
%
%    X         5-vect data
%    L0,L45    two linear polarization 5-vect base

% Version 2.0 - September 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


CL=(L0+1j*L45)/sqrt(2);
CR=(L0-1j*L45)/sqrt(2);

mf0=mf_5vec(X,L0);
mf45=mf_5vec(X,L45);
mfL=mf_5vec(X,CL);
mfR=mf_5vec(X,CR);

amp2(1)=abs(mf0)^2+abs(mf45)^2;
[eta(1) psi(1)]=ab2etapsi(mf0,mf45);
rap(1)=abs(mf0/mf45);
ang(1)=angle(mf0/mf45)*180/pi;

neta=100;
npsi=181;
[eta(2) psi(2) amp2(2)]=etapsi_mf(X,L0,L45,neta,npsi,1,0);
[a b]=etapsi2ab(eta(2),psi(2));
rap(2)=abs(a/b);
ang(2)=angle(a/b)*180/pi;

[a b amp2(3)]=calc_mfmax(L0,L45,mf0,mf45,0);
[eta(3) psi(3)]=ab2etapsi(a,b);
rap(3)=abs(a/b);
ang(3)=angle(a/b)*180/pi;

[eta(4) psi(4) amp2(4)]=etapsi_mf(X,CL,CR,neta,npsi,2,0);
[a b]=etapsi2ab(eta(4),psi(4));
rap(4)=abs(a/b);
ang(4)=angle(a/b)*180/pi;

ac=mfL/sqrt(abs(mfL)^2+abs(mfR)^2);
bc=mfR/sqrt(abs(mfL)^2+abs(mfR)^2);
A=abs(ac/bc);
fi=angle(ac/bc)*180/pi;
eta(5)=(A-1)/(A+1);
psi(5)=-fi/4;
amp2(5)=abs(mfL)^2+abs(mfR)^2;
rap(5)=abs(ac/bc);
ang(5)=angle(ac/bc)*180/pi;


disp('    5 methods output')
fprintf('eta  : %f %f %f %f %f \n',eta);
fprintf('psi  : %f %f %f %f %f \n',psi);
fprintf('amp2 : %f %f %f %f %f \n',amp2);
fprintf('rap  : %f %f %f %f %f \n',rap);
fprintf('angle: %f %f %f %f %f \n',ang);
disp(' ')
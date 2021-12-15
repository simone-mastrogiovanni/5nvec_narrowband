function [eta psi amp2 a b]=par4dof_3meth(X,L0,L45)
% par4dof_3meth  computes parameters from data with 3 methods
%                The 3 methods are:
%                - empirical method (maximum content)
%                - full map
%                - analytic maximum
%
%    X         5-vect data
%    L0,L45    two linear polarization 5-vect base

% Version 2.0 - September 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

mf0=mf_5vec(X,L0);
mf45=mf_5vec(X,L45);

amp2(1)=abs(mf0)^2+abs(mf45)^2;
[eta(1) psi(1)]=ab2etapsi(mf0,mf45);

neta=100;
npsi=181;
[eta(2) psi(2) amp2(2)]=etapsi_mf(X,L0,L45,neta,npsi,1,0);

[a b amp2(3)]=calc_mfmax(L0,L45,mf0,mf45,0);
[eta(3) psi(3)]=ab2etapsi(a,b);

disp('    3 methods output')
fprintf('eta  : %f %f %f \n',eta);
fprintf('psi  : %f %f %f \n',psi);
fprintf('amp2 : %f %f %f \n',amp2);
function x=corr_unif(N,ro)
% uniform correlated data with the rank method
%
%   x=corr_unif(N,ro)
%
%  N     length
%  ro    correlation coeff

% Version 2.0 - August 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

x1=corr_numb(N,ro,1);
x=x1*0;

[r1,ir1]=sort(x1(:,1),'descend');
[r2,ir2]=sort(x1(:,2),'descend');
x(ir1,1)=(1:N)/N;
x(ir2,2)=(1:N)/N;
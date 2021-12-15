function par=clust_par(ccand)
% parameter characterizing a cluster
%
%    par=clust_par(ccand)
%
%  ccand(Numer,9)    candidate matrix
%
%  par(1)     numerosity
%  par(2:5)   [fr lam bet sd] sigmas
%  par(6:11)  [fr lam bet sd] ros

% Version 2.0 - July 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

par=zeros(1,11);
[N,dum]=size(ccand);
par(1)=N;
if N > 1
    A=ccand(:,1:4);
    par(2:5)=std(A);
    cc=corrcoef(A);
    par(6:8)=cc(1,2:4);
    par(9:10)=cc(2,3:4);
    par(11)=cc(3,4);
end
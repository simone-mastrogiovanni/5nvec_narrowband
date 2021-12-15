function k=LM_bernoul(p,N)
% LM_bernoul  prove alla Bernoulli
%
%    p     probabilità di successo
%    N     numero prove

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

r=sign(p-rand(N,1));

figure,stem(r,'MarkerFaceColor','red'),ylim([-2 2])

k=length(find(r>0));
str=sprintf('Prove alla Bernoulli: p = %f, N = %d,  %d successi',p,N,k);
xlabel(str)
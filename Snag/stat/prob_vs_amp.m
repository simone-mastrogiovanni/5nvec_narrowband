function [prob,pdens]=prob_vs_amp(in,dp)
% probability vs amplitude
%
%  in    array or gd or gd2
%  dp    prob resolution (def 0.01)

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('dp','var')
    dp=0.01;
end

if isa(in,'gd')
    in=y_gd(in);
elseif isa(in,'gd2')
    in=y_gd2(in);
end

p=0:dp:1;
n=length(p);
A=p*0;

for i = 1:n
    A(i)=prctile(in,p(i)*100);
end

figure,plot(A,p),grid on,hold on,plot(A,p,'r.')
figure,semilogy(A,p),grid on,hold on,plot(A,p,'r.')

dA=diff(A);
dens=1./dA;
dens=dens/(sum(dens)*dp);

xdens=A(1:n-1)+dA/2; %figure,plot(A(1:n-1),xdens-A(1:n-1))
figure,plot(xdens,dens),grid on,hold on,plot(xdens,dens,'r.')
figure,semilogy(xdens,dens),grid on,hold on,plot(xdens,dens,'r.')

prob=gd(A);
prob=edit_gd(prob,'x',A,'y',p);
pdens=gd(dens);
pdens=edit_gd(pdens,'x',xdens,'y',dens);
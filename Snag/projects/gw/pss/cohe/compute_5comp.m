function [A fr fact0corr]=compute_5comp(gin,fr0,mask)
% COMPUTE_5COMP  computes the five complex components (FT) of the signal of the
%                type  exp(j*om*t)
%
%   [a fr]=compute_5comp(gin,fr0)
%
%     gin        input gd
%     fr0        source apparent frequency
%     mask       if present, weights gin
%
%     A          complex components
%     fr         frequencies
%     fact0corr  Ttot/T : factor to multiply A to correct for holes

% Version 2.0 - May 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

y=y_gd(gin);
t=x_gd(gin);
t=t-t(1);
dt=dx_gd(gin);
n=n_gd(gin);

if exist('mask','var')
    y=y.*mask(:);
end

FS=1/86164.09053083288;

fr=fr0+(-2:2)*FS;

i=find(y);
T=dt*length(i);
Ttot=dt*length(y);
fact0corr=Ttot/T;

disp('     compute_5comp')
disp(' i   fr   real  imag  abs angle')

for i = 1:5
    A(i)=sum(y.*exp(-1j*2*pi*fr(i)*t))*dt/Ttot;
    disp(sprintf(' %d  %f  %e  %e  %e  %7.2f ',i-3,fr(i),real(A(i)),imag(A(i)),abs(A(i)),angle(A(i))*180/pi))
end

disp(sprintf('   power :  %e',sum(abs(A).^2)/T))
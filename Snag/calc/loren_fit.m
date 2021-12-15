function par=loren_fit(gin)
% lorentzian fit
%
%    gin   gd containing a chunk of the power spectrum
%
%    par.fr0  frequency
%       .tau  tau (power)

% Snag Version 2.0 - November 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=y_gd(gin);
x=x_gd(gin);
x0=mean(x);
df=dx_gd(gin);
inif=ini_gd(gin);

y1=1./y;
unc=sqrt(y1);

a=gen_lin_fit(x-x0,y1,1,1,2,1);

fr1=-a(2)/a(1);
par.fr0=fr1+x0;
par.tau0=1/sqrt(a(3)-4*pi*fr1^2);

par.a=a;
par.x0=x0;

f=abs(fft(y));
dt=1/(length(f)*df);
i=2;

while f(i)>f(1)*0.3679;
    i=i+1;
end

par.dt=dt;
par.i=i;
par.tau=(i-1)*dt;

figure,semilogy(f(1:3*i)),grid on,hold on,semilogy(f(1:3*i),'r.')
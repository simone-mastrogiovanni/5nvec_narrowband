function out=bp_par_estim(h1,h2)
% parameter estimation for binary ps
%
%       out=bp_par_estim(h1,h2)
%
%   h1,h2   first and second normalized harmonics (complex numbers)

% Snag Version 2.0 - March 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

ang=180-angle(h2/h1^2)*180/pi;

F=zeros(50,1);

for i = 1:50
    ecc=(i-1)/50;
    E(i)=ecc;
    [dop,rom,harm1]=elliptic_orbit(1,1,ecc,[45,45],1000);
    dang=180-angle(harm1(2)/harm1(1)^2)*180/pi-45;
    D(i)=dang;
    ang1=ang-dang*sin(2*ang*pi/180);
    [dop,rom,harm]=elliptic_orbit(1,1,ecc,[ang1,45],1000);
    F(i)=abs(harm(1));
end

figure;plot(E,F);grid on
figure;plot(E(2:50),D(2:50));grid on

out.ecc=spline(F,E,abs(h1));

out.ang=ang;

[dop,rom,harm]=elliptic_orbit(1,1,out.ecc,[ang,45],1000);
dang=180-angle(harm1(2)/harm1(1)^2)*180/pi-45;
ang1=ang-dang*sin(2*ang*pi/180);

out.ang1=ang1;
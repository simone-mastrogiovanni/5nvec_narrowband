function [v,vn]=multisour_ant_2_5vec(ant,multisour)
% creates 5vec from many sources and one ant
%
%    v=multisour_ant_2_5vec(ant,multisour)
% 
%   ant        antenna structure
%   multisour  (N,4) [alpha delta eta psi]
%
%   v          output 5-vec

% Snag version 2.0 - January 2015 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[N,dum]=size(multisour);
v=zeros(N,5);
vn=zeros(N,1);

% a=sour.a*pi/180;
% d=sour.d*pi/180;
% eta=sour.eta;
% psi=sour.psi*pi/180;
% seta=sign(eta);

l=ant.lat*pi/180;
long=ant.long*pi/180;
az=ant.azim*pi/180;

for i = 1:N
    a=multisour(i,1)*pi/180;
    d=multisour(i,2)*pi/180;
    eta=multisour(i,3);
    psi=multisour(i,4)*pi/180;
    
    al=exp(-1j*(a-long));
    
    c2a=cos(2*az);
    c2d=cos(2*d);
    c2l=cos(2*l);
    s2a=sin(2*az);
    s2d=sin(2*d);
    s2l=sin(2*l);

    cd=cos(d);
    cl=cos(l);
    sd=sin(d);
    sl=sin(l);

    a0=-(3/16)*(1+c2d)*(1+c2l)*c2a;
    a1c=-(1/4)*s2d*s2l*c2a;
    a1s=-(1/2)*s2d*cl*s2a;
    a2c=(-1/16)*(3-c2d)*(3-c2l)*c2a;
    a2s=-(1/4)*(3-c2d)*sl*s2a;

    b1c=-cd*cl*s2a;
    b1s=(1/2)*cd*s2l*c2a;
    b2c=-sd*sl*s2a;
    b2s=(1/4)*sd*(3-c2l)*c2a;

    A(1)=(al^-2)*(a2c+1j*a2s)/2;
    A(2)=(al^-1)*(a1c+1j*a1s)/2;
    A(3)=a0;
    A(4)=(al)*(a1c-1j*a1s)/2;
    A(5)=(al^2)*(a2c-1j*a2s)/2;

    B(1)=(al^-2)*(b2c+1j*b2s)/2;
    B(2)=(al^-1)*(b1c+1j*b1s)/2;
    B(3)=0;
    B(4)=(al)*(b1c-1j*b1s)/2;
    B(5)=(al^2)*(b2c-1j*b2s)/2;

    L0=A;
    L45=B;
    A1=sqrt(norm(A)^2+norm(B)^2)*A/norm(A);
    B1=sqrt(norm(A)^2+norm(B)^2)*B/norm(B);
%     CL=(A1+1j*B1)/sqrt(2);
%     CR=(A1-1j*B1)/sqrt(2);

    Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi));
    Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi));
    v(i,:)=Hp*L0+Hc*L45;
    vn(i)=norm(v(i,:));
end
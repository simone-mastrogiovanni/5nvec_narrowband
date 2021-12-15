function [sigl sigr asigl asigr]=crea_all_5sourA(hp,hx,neps,npsi)
% CREA_ALL_5SOUR  starting from hp and hx, creates the 5 components for all
%                 possible sources response. The computation is performed
%                 for the two rotations
%        !! ERRONEOUS ! use crea_all_5sour
%
%       sig=crea_all_5sour(hp,hx,neps,npsi)
%
%    hp          h plus antenna response
%    hx          h cross antenna response
%    neps,npsi   number of points in the parameter spaces

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

sigl=zeros(neps,npsi,5);
sigr=sigl;
asigl=zeros(neps,npsi);
asigr=asigl;

for i = 1:neps
    eps=(i-1)/(neps-1);
    for j = 1: npsi
        psi=pi*(j-1)/(2*npsi);
        lp=eps*cos(2*psi);
        lx=eps*sin(2*psi);
        cp=exp(1j*2*psi)*(1-eps)/sqrt(2);
        cx=-1j*exp(1j*2*psi)*(1-eps)/sqrt(2);
        a=hp*(lp+cp)+hx*(lx+cx);
        sigl(i,j,:)=a;
        asigl(i,j)=sum(abs(a).^2);
        b=hp*(lp+cp)-hx*(lx+cx);
        b=hp*(lp+cp.')+hx*(lx+cx.');
        sigr(i,j,:)=b;
        asigr(i,j)=sum(abs(b).^2);
    end
end

for i = 1:neps
    eps(i)=(i-1)/(neps-1);
end
for i = 1:npsi
    psi(i)=90*(i-1)/npsi;
end

figure,image(psi,eps,asigl,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon')
figure,image(psi,eps,asigr,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon')
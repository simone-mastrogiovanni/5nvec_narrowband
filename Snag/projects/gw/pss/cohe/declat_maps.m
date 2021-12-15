function [M Mp Mc R C degs]=declat_maps(ndeg,azim)
% DECLAT_MAP  creates declination/latitude maps
%
%    [M eta psi histM xhistM]=etapsi_map(v5A,v5B,neta,npsi,cont)
%
%     ndeg   number of degrees for each dimension
%     azim   antenna azimut
%
%     M       map |A+|^2 + |Ax|^2
%     Mp      map |A+|^2
%     Mx      map |Ax|^2
%     R       map |A+|^2/|Ax|^2

% Version 2.0 - September 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dd=180/(ndeg-1);
degs=(-90:dd:90);
Mp=zeros(ndeg,ndeg);
Mc=Mp;
R=Mp;
C=Mp;

ant.long=0;
ant.azim=azim;
sour.a=0;
sour.eta=0;
sour.psi=0;

for i = 1:ndeg
    sour.d=degs(i);
    for j = 1:ndeg
        ant.lat=degs(j);
        [L0 L45 CL]=sour_ant_2_5vec(sour,ant);
        Mp(i,j)=norm(L0)^2;
        Mc(i,j)=norm(L45)^2;
        R(i,j)=(Mp(i,j)+0.01)/(Mc(i,j)+0.01);
        M(i,j)=Mp(i,j)+Mc(i,j);
        C(i,j)=norm(CL)^2;
    end
end

figure,image(degs,degs,M,'CDataMapping','scaled'),colorbar
xlabel('Declination'),ylabel('Latitude'),title('|A+|^2+|Ax|^2')

figure,image(degs,degs,Mp,'CDataMapping','scaled'),colorbar
xlabel('Declination'),ylabel('Latitude'),title('|A^+|^2')

figure,image(degs,degs,Mc,'CDataMapping','scaled'),colorbar
xlabel('Declination'),ylabel('Latitude'),title('|A^x|^2')

figure,image(degs,degs,log10(R),'CDataMapping','scaled'),colorbar
xlabel('Declination'),ylabel('Latitude'),title('|A+|^2/|Ax|^2')

figure,image(degs,degs,C,'CDataMapping','scaled'),colorbar
xlabel('Declination'),ylabel('Latitude'),title('Circular Polarization')
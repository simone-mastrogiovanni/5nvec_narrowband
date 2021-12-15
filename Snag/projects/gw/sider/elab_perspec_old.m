function [map asp aspmax]=elab_perspec(g2,irot,phas,capt)
% elab_perspec  elaborates period spectrograms created by phfr_spec2
%
%    g2     input ph_fr_sp gd2
%    irot   rotation index (integer)
%    phas   phase correction
%    capt   caption

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if  ~exist('capt','var')
    capt='';
end

if  ~exist('phas','var')
    phas=0;
end

SF=1.002737909350795;

M=y_gd2(g2);
[n1 n2]=size(M);
M1=M;
h=x2_gd2(g2);
fr=x_gd2(g2);
inifr=ini_gd2(g2);
dfr=dx_gd2(g2);
asp=zeros(1,n2);
aspmax=asp;

for i = 1:n2
    y=M(i,:);
    [ma ima]=max(y);
    [mi imi]=min(y);
    asp(i)=(ma-mi)/2;
    aspmax(i)=ma-1;
    ir=round((i-(n2+1)/2)*irot);
    M1(i,:)=rota(y,mod(ir,n1));
end

map=g2;
% map=edit_gd2(map,'y',M1,'ini',inifr,'dx',dfr);inifr,dfr,map
map=edit_gd2(map,'y',M1');map

asp=gd(asp);
asp=edit_gd(asp,'ini',inifr,'dx',dfr);
aspmax=gd(aspmax);
aspmax=edit_gd(aspmax,'ini',inifr,'dx',dfr);

image_gd2(map),grid on
title([capt ' - phase-frequency epoch-folding map']),ylabel('Hours'),xlabel('Frequency')
hold on,plot([SF SF],[0 24],'--m')

figure,plot(asp),hold on,plot(asp,'r.')
mi=min(min(asp),min(aspmax));
ma=max(max(asp),max(aspmax));
delfr=0.002737909350795;
plot(aspmax,'r'),plot(aspmax,'.')
plot([1 1],[mi ma],'r'),plot([1+delfr 1+delfr],[mi ma],'g'),plot([1-delfr 1-delfr],[mi ma],'g--'),plot([1+2*delfr 1+2*delfr],[mi ma],'r--')
title([capt ' - phase-frequency epoch-folding spectrum']),ylabel('Amplitude'),xlabel('Frequency');
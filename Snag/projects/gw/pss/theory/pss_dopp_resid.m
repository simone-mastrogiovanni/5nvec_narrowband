function out=pss_dopp_resid(T,ant,pos)
% pss frequency residuals for incorrect doppler
%
%   T     [tin tfi] mjd
%   ant   antenna structure
%   pos   sky position [ra decl] deg

% Snag Version 2.0 - January 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S.D'Antonio and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dtsec=100;
dalf=1;
ddelt=1;
t1=T(1):dtsec/86400:T(2);
out.t1=t1;

fr1=doppler2(t1,1,pos(1),pos(2),ant.long,ant.lat,0)-1;
fr2=doppler2(t1,1,pos(1)+dalf,pos(2),ant.long,ant.lat,0)-1;
fr3=doppler2(t1,1,pos(1),pos(2)+ddelt,ant.long,ant.lat,0)-1;
out.fr1=fr1;
out.fr2=fr2;
out.fr3=fr3;

figure,plot(t1-t1(1),fr1),hold on,grid on,plot(t1-t1(1),fr2,'r')
title('Adimensional Doppler frequency shift'),xlabel('days'),ylabel('Hz')

dfr=diff(fr1)/dtsec;
dfr=[0 dfr];
figure,plot(t1-t1(1),dfr),grid on
title('Variation of adimensional Doppler frequency'),xlabel('days'),ylabel('Hz')

dfra=(fr2-fr1)/dalf;
figure,plot(t1-t1(1),dfra),grid on
title('Adimensional residual frequency (alpha var)'),xlabel('days'),ylabel('Hz')

dfrd=(fr3-fr1)/ddelt;
figure,plot(t1-t1(1),dfrd),grid on
title('Adimensional residual frequency (delta var)'),xlabel('days'),ylabel('Hz')
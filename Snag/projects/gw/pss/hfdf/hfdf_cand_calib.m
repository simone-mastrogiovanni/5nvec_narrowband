function candout=hfdf_cand_calib(calib,sky_calib,candin)
% adds the "sky-conventional" h-amplitude to the cand table
%
%    candout=hfdf_cand_calib(calib,sky_calib,candin)
%
%  calib      Hough calibration data-base structure or run string ('VSR2' or 'VSR4')
%              (IN LIGO MEAN EQUIVALENT UNITS)
%  sky_calib  calibration fo the declination 
%  candin     standard 15 (or 16) raw data (important are 10 (fr), 12 (decl), 14 (amp) 
%         
%      calib and sky_calib are in data_an_pss or similar

% Version 2.0 - February 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

[n1,n2]=size(candin.cand);
candout.cand=zeros(n1+1,n2);
candout.info=candin.info;

xsk=x_gd(sky_calib);
ysk=y_gd(sky_calib);

if n1 == 15
    h=hfdf_calib(calib,candin.cand(10,:),candin.cand(14,:));
    b=abs(candin.cand(12,:));
    b=interp1(xsk,ysk,b);
    candout.cand(1:15,:)=candin.cand;
    candout.cand(16,:)=h.*b;
elseif n1 == 8
else
end
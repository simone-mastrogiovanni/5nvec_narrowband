function [fr,fr1,fr2,dy,dy1,dy2]=vfs_freq(in,cal)
% frequency evaluation
%
%   in    input gd (complex (if real, it is converted to analytical signal)
%   cal   > 0 -> calibrated (only on fr), > 1 calibration curve

% Version 2.0 - October 2015
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('cal','var')
    cal=0;
end
y=y_gd(in);
dt=dx_gd(in);
n=length(y);

if isreal(y)
    y=fft(y);
    y(n/2+1:n)=0;
    y=ifft(y);
end

[dy,dy1,dy2]=gd_deriv(y);

fr1=(abs(dy1)./abs(y))/(2*pi*dt);
fr2=(abs(dy2)./abs(y))/(2*pi*dt);
fr=(fr1+fr2)/2;

if cal > 0
    fr0=mean(fr);
    LFR=(-1:0.005:1)*fr0;
    [gout,FRin]=vfs_create(1000,-dt,fr0,[0 0 0],LFR);
    FRout=y_gd(vfs_freq(gout));
    frcal=spline(FRout,FRin,fr);
%     frcal=interp1(FRout,FRin,fr);
    if cal > 1
        figure,plot(FRout,FRin./FRout),grid on,xlabel('FRout'),ylabel('FRin/FRout')
        figure,plot(fr),hold on,grid on,plot(frcal,'r'),title('blue uncalibrated, red calibrated')
    end
    fr=frcal;
end

fr1=edit_gd(in,'y',fr1);
fr2=edit_gd(in,'y',fr2);
fr=edit_gd(in,'y',fr);
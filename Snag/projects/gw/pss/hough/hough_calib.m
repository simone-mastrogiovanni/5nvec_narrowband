function [h,kf,par,skel]=hough_calib(HC_db,fr,N)
% Calibration of an Hough map
%
%   [h,kf,par,skel]=hough_calib(HC_db,fr,N)
%
%  HC_db   Hough calibration data-base structure or run string ('VSR2' or 'VSR4')
%  fr      frequency (single or one for each amplitude)
%  N       Hough amplitude
%
%  h       wave amplitude
%  kf      frequency index (if single)
%  par     parameters at that frequency (if single)
%  skel    skeleton
%
%  HC_db.base(8,n)     1 - ini fr, 2 - NoiseAVER, 3 - NoiseMEDIAN, 4 - NoiseSTD
%                      5,6 - min,max Hough amp, 7,8 - p,q of linear fit
%       .xsplin(21,n)  abscissa of calibration curve
%       .ysplin(21,n)  ordinate of calibration curve

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ischar(HC_db)
    snag_local_symbols
    if strcmpi(HC_db,'VSR2')
        load([snagdir 'data' dirsep 'VSR2_Calib_DB'])
        HC_db=VSR2_Calib_DB;
    end
    if strcmpi(HC_db,'VSR4')
        load([snagdir 'data' dirsep 'VSR4_Calib_DB'])
        HC_db=VSR4_Calib_DB;
    end
end
n=length(N);
nfr=length(fr);
h=zeros(1,n);
par=0;

base=HC_db.base;
xsplin=HC_db.xsplin;
ysplin=HC_db.ysplin;

base2=base(2,:);

kf=0;
if nfr == 1
    kfr=ind_fr(base2,fr);
    kf=kfr;
end

for i = 1:length(N)
    if nfr > 1
        kfr=ind_fr(base2,fr(i));
    else
        par=base(:,kfr);
        skel(:,1)=xsplin(:,kfr);
        skel(:,2)=ysplin(:,kfr);
    end
        
    if N(i) <= base(3,kfr)
        h(i)=0;
    elseif N(i) > base(3,kfr) && N(i) <= base(6,kfr)
        h(i)=spline(xsplin(:,kfr),ysplin(:,kfr),N(i));
%         disp('spline')
    else
        h(i)=base(7,kfr)*N(i)+base(8,kfr);
%         disp('linear extrapolation')
    end
end



function kfr=ind_fr(base2,fr)

kfr=0; %length(base2),fr,figure,plot(base2)

for i = 1:length(base2)
    if base2(i) > 0
        kfr=i;
        if fr < i+1
            kfr=i;
            break
        end
    end
end

if abs(fr-kfr) > 1
    disp(sprintf(' frequency %f based on %d',fr,kfr))
end
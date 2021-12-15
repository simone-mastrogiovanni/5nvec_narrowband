function [gw nois wien]=ps_wiener(g,thr,limw,icwhit)
% PS_WIENER computes the Wiener filtering (NWF) for a (known) source
%           the input data are adaptively clipped
%
%        [gw nois ecq tecq wien]=ps_wiener(g,thr,icwhit)
%
%    g       gd with time series data, as obtained by pss_band_recos
%    thr     cr threshold (typically 4.5)
%    limw    maximum admissible value of NWF
%    icwhit  = 1 (if present) -> whitening
%    
%    gw      filtered gd
%    nois    standard deviation of the noise

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('icwhit','var')
    icwhit=0;
end
lenstat=1000;
[gout nois]=ada_clip_c(g,10,lenstat,thr,0);

gin=y_gd(gout)./y_gd(nois);
out=check_inf(gin,1);
gin(out)=0;
out=check_nan(gin,1);
gin(out)=0;
gin=real(gin);
i1=find(gin);
gin=gin(i1);
dx=0.02;
x=(-thr*1.05):dx:(thr*1.05);
h=histc(gin,x);
figure,semilogy(x,h),hold on,semilogy(x,length(gin)*(exp(-x.^2/2)/sqrt(2*pi))*dx,'r'),grid on;
title('WF input data distribution')

if icwhit ~= 1
    gin=1./y_gd(nois).^2;
    out=check_inf(gin,0);
    gin(out)=0;
    out=check_nan(gin,0);
    gin(out)=0;
    nw=length(gin);
    wien=(nw*dx_gd(nois))*gin./(sum(gin)*dx_gd(nois));
    if exist('limw','var') && limw > 0
        i1=find(wien > limw);
        wien(i1)=0;
        sw=sum(wien)/length(wien);
        wien=wien/sw;
    end
    gin=y_gd(gout).*wien;
    capt='ada_clip and wiener on ps';
    check_wien=sum(wien)/length(wien);
    fprintf(' --> Check NWF : %f  (should be 1) \n',check_wien)
else
    gin=y_gd(gout)./y_gd(nois);
    capt='ada_clip and whitening on ps';
end

gw=edit_gd(gout,'y',gin,'capt',capt);
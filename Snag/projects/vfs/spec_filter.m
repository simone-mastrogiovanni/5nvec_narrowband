function out=spec_filter(gin,sour,ant,res,lp)
% applies the mean spectral filter
%
%    gout=spec_filter(gin,sour,ant,res,lp)
%
%   gin    input gd
%   sour   source
%   ant    antenna
%   res    resolution
%   lp     low pass (samples, def 512)

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Tsid=86164.090530833; % at epoch2000

if ~exist('lp','var')
    lp=512;
end

spfilt=crea_spec_filter(sour,ant);
out.spfilt=spfilt;
s=gd_pows(gin,'resolution',res,'short');
y=y_gd(s);
nn=n_gd(s);
df=dx_gd(s); %n,nn,size(y),size(tfilt)

lfilt=2*ceil((2.5/Tsid)/df)+1;
ff=(-floor(lfilt/2):floor(lfilt/2))*df;
ff5=(-2:2)/Tsid;
DF=2.5/Tsid;
fma=ff*0;

for i = 1:5
    fma=fma+spfilt(i).*exp(-((ff-ff5(i)).^2)/(2*(df*res)^2));
end
out.fma=fma;
y=filter(fma,1,y);

s=edit_gd(s,'y',y,'ini',ini_gd(s)-DF);

rmed=running_median(s,lp,1);
med=running_median(s,lp,0);
out.med=med;

gout=s./rmed;

out.rap=gout;
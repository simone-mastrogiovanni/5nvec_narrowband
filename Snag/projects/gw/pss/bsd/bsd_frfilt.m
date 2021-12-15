function [ffrbsd,fil]=bsd_frfilt(in,frfilt)
% frequency filter for a bsd gd produced by bsd_largerband
%
%         ffrbsd=bsd_frfilt(in,frfilt)
%
%   in      input bsd
%   frfilt  frequency filter or 'white' or 'wiener'
%
% use filt_renorm for renormalization

% Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

fil=0;
cont=cont_gd(in);
frange=cont.frange;
dt=dx_gd(in);
n=n_gd(in);
df=1/(n*dt);
i1=round(frange(1)/df)+1;frange
i2=min(n,round(frange(2)/df));i1,i2
y=y_gd(in);
y=fft(y);

switch frfilt
    case 'white'
        fil=1./abs(y);
        mf=mean(fil(i1:i2));mf
        fil=fil/mf;mean(fil(i1:i2))
        fil(1:i1)=1;
        fil(i2+1:n)=1;
        y=y.*fil;
    case 'wiener'
        fil=1./abs(y).^2;
        mf=mean(fil(i1:i2));mf
        fil=fil/mf;mean(fil(i1:i2))
        fil(1:i1-1)=1;
        fil(i2+1:n)=1;
        y=y.*fil;
    otherwise
        y=y.*frfilt;
end

ii=find(isnan(real(y)));
if length(ii) > 0
    fprintf(' %d NaN data, fraction %f \n',length(ii),length(ii)/length(y))
end
y(ii)=0;
y=ifft(y);

ffrbsd=edit_gd(in,'y',y);
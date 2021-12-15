function [gout f]=gd_band_filter(ic,gin,band)
% GD_BAND_FILTER  fr.dom. band filtering
%
%     [gout f]=gd_band_filter(ic,gin,band)
%
%   ic      1 -> central interval; 2 -> full interval
%   gin     input gd
%   band    [inifr finfr trans ic simm] initial, final, transition,simmetrization (real data) (0 or 1)
%           if absent, interactive

% Version 2.0 - November 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ic ~= 1
    ic=2;
end
dt=dx_gd(gin);
n=n_gd(gin);
sfr=1/dt;
ssfr=sprintf('%f',sfr);
ssfr4=sprintf('%f',sfr/4);
if ~exist('band','var')
    prompt={'Initial frequency'...
          'Final frequency'...
          'Transition band'...
          'Symmetric (real data) ?'};
    default={'0',ssfr4,'0','1'};

    answ=inputdlg(prompt,['Sampling frequency ' ssfr],1,default);

    band(1)=eval(answ{1});
    band(2)=eval(answ{2});
    band(3)=eval(answ{3});
    band(4)=eval(answ{4});
end

if band(3) == 0
    band(3)=(band(3)-band(2))/200;
end

if band(4) ~= 0
    band(4)=1;
end

N=floor(n/4)*4;
Dfr=sfr/N;

fr1=band(1)-band(3);
fr2=band(1);
fr3=band(2);
fr4=band(2)+band(3);

i1=round(fr1/Dfr)+1;
if i1 < 1
    i1=1;
elseif i1 > N
    i1=N;
end
i2=round(fr2/Dfr)+1;
if i2 < 1
    i2=1;
elseif i2 > N
    i2=N;
end
i3=round(fr3/Dfr)+1;
if i3 < 1
    i3=1;
elseif i3 > N
    i3=N;
end
i4=round(fr4/Dfr)+1;
if i4 < 1
    i4=1;
elseif i4 > N
    i4=N;
end

f=zeros(1,N);
f(i1:i2)=((i1:i2)-i1)/(i2-i1+1);
f(i4:-1:i3)=((i3:i4)-i3)/(i4-i3+1);
f(i2:i3)=1;

if band(4) == 1
    f(N:-1:N/2+2)=f(2:N/2);
    f(N/2+1)=f(N/2);
end

frfilt=create_frfilt(f);

switch ic
    case 1
        gout=gd_frfilt(gin,frfilt.',band(4));
    case 2
        y=y_gd(gin);
        y=fft(y).*f.';
        y=ifft(y);
        if band(4) == 1
            y=real(y);
        end
        gout=edit_gd(gin,'n',N,'y',y);
end


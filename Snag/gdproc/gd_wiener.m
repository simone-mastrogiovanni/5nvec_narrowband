function [gdout,frfilt]=gd_wiener(gdin,filtlen,icreal)
%GD_WIENER  frequency domain wiener filtering of a gd
%
%   [gdout,frfilt]=gd_wiener(gdin,filtlen,icreal)
%
%    gdin      sampled data input gd
%    filtlen   filter length (divisible by 4)
%    icreal    = 1 if data are real
%
%    gdout     output data
%    frfilt    output frequency filter

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

norm=0;  % standard normalization

spin=gd_pows(gdin,'length',filtlen,'window',2,'nobias')
sp=y_gd(spin);
frfilt=1./sp;

frfilt=create_frfilt(frfilt);

switch norm
    case 0
        su=2*abs(sum(frfilt(1:filtlen/2)));
        frfilt=filtlen*frfilt/su;
end

len=filtlen;
len4=round(len/4);
if len4*4 ~= len
    disp('incorrect frequency filter length');
    return
end
len2=len4*2;

y=y_gd(gdin);
yout=y*0;
ly=length(y);
y1=zeros(len,1);
lenmin=min(len4*3,ly);
ini=0; %size(y1),size(frfilt)

y1(len4+1:len4+lenmin)=y(1:lenmin);

while ini < ly
    y2=fft(y1).*frfilt;
    y2=ifft(y2);
    if icreal == 1
        y2=real(y2);
    end
    lenmin=min(len2,ly-ini);
    yout(ini+1:ini+lenmin)=y2(len4+1:len4+lenmin);
    ini=ini+len2;
    if ini >= ly
        break
    end
    
    lenmin=min(len2,ly-ini-len4);
    y1=y1*0;
    y1(1:lenmin+len2)=y(ini+1-len4:ini+lenmin+len4);
end

yout(1:len4)=0;
yout(ly-len4+1:ly)=0;

gdout=gdin;
gdout=edit_gd(gdout,'y',yout,'addcapt','wiener filtering of:');
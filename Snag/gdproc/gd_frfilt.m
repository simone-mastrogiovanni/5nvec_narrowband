function gdout=gd_frfilt(gdin,frfilt,icreal)
%GD_FRFILT  frequency filtering of a gd or double array
%
%    gdin     sampled data input gd or double array
%    frfilt   frequency filter (full frequency domain; length divisible by 4)
%    icreal   =1 impose real output
%
%    gdout    output data

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

len=length(frfilt);
len4=round(len/4);
if len4*4 ~= len
    disp('incorrect frequency filter length');
    return
end
len2=len4*2;

if isnumeric(gdin)
    y=gdin;
else
    y=y_gd(gdin);
end

yout=y*0;
ly=length(y);
y1=zeros(len,1);
lenmin=min(len4*3,ly);
ini=0;

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

len4a=floor(len4*1.05);
yout(1:len4a)=0;
yout(ly-len4a+1:ly)=0;
% vign=(1-cos((0:19)*pi/20))*0.5;
% yout(len4a+1:len4a+20)=yout(len4a+1:len4a+20).*vign';
% yout(ly-len4a:-1:ly-len4a-19)=yout(ly-len4a:-1:ly-len4a-19).*vign';

if isnumeric(gdin)
    gdout=yout;
else
    gdout=gdin;
    gdout=edit_gd(gdout,'y',yout,'addcapt','frequency filter on:');
end
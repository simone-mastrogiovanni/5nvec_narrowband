function [gdout,frfilt]=gd_decim(gdin,decim,fftlen,icreal)
%GD_DECIM  decimation with frequency filtering of a gd or double array
%
%    [gdout,frfilt]=gd_decim(gdin,decim,fftlen,icreal)
%
%    gdin     sampled data input gd or double array
%    decim    decimation ratio; also non-integer (> 1; one every decim samples)
%    fftlen   length of the fft (divisible by 4; 0 automatic)
%    icreal   =1 impose real output
%
%    gdout    output data

% Version 2.0 - March 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isnumeric(gdin)
    y=gdin;
    dt=1;
    icgd=0;
else
    y=y_gd(gdin);
    dt=dx_gd(gdin);
    icgd=1;
end

ly=length(y);

if fftlen <= 0
    fftlen=16384;
end
len=fftlen;
len4=round(len/4);
if len4*4 ~= len
    disp('incorrect frequency filter length');
    return
end
len2=len4*2;

cutfr=round(fftlen/(2*decim)-1);
frfilt=zeros(fftlen,1);
frfilt(1:cutfr+1)=1;
lvign=round(fftlen/1000);
if lvign < 4
    lvign=4;
end
vign=(cos((1:lvign)*pi/lvign)+1)/2;

frfilt(cutfr-lvign+2:cutfr+1)=frfilt(cutfr-lvign+2:cutfr+1).*vign.';
frfilt(fftlen:-1:fftlen-cutfr+1)=frfilt(2:cutfr+1);

frfilt=create_frfilt(frfilt);
%figure,plot(frfilt)

yout=y*0;
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
yout=yout(round(1:decim:ly));

if isnumeric(gdin)
    gdout=yout;
else
    gdout=gdin;
    gdout=edit_gd(gdout,'y',yout,'dx',dx_gd(gdin)*decim,'addcapt','frequency filter on:');
    
    frfilt=gd(frfilt);
    frfilt=edit_gd(frfilt,'dx',1/(dt*fftlen),'capt','anti-aliasing filter');
end
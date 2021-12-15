function gdout=gd_whitening(gdin,filtlen,icreal,nhp,hpfr)
%GD_WHITENING  frequency domain whitening of a gd
%
%    gdin      sampled data input gd
%    filtlen   filter length (divisible by 4)
%    icreal    = 1 if data are real
%    nhp       number of high-pass filters
%    hpfr      high-pass frequency (normalized to sampling frequency)
%
%    gdout    output data

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=y_gd(gdin);

if nhp > 0
    am1=crea_am('high',hpfr);
    amf=am1;
    for i = 1:nhp-1
        amf=am_multi(amf,am1);
    end
    amf.bilat=1;
    x=am_filter(x,amf);
    gdin=edit_gd(gdin,'y',x);
end

spin=gd_pows(gdin,'length',filtlen,'window',2,'nobias')
sp=y_gd(spin);
frfilt=1./sqrt(sp);
frfilt=create_frfilt(frfilt);

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

% if nhp > 0
%     yout=am_filter(yout,amf);
% end

yout(1:len4)=0;
yout(ly-len4+1:ly)=0;

gdout=gdin;
gdout=edit_gd(gdout,'y',yout,'addcapt','whitening of:');
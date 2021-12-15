function [gdout,frfilt,am1]=gd_wiener_hp(gdin,filtlen,icreal,hpfr,cofr)
%GD_WIENER_HP  frequency domain wiener filtering of a gd followed by a high-pass
%
%   [gdout,frfilt,am1]=gd_wiener_hp(gdin,filtlen,icreal,hpfr)
%
%    gdin      sampled data input gd
%    filtlen   filter length (divisible by 4)
%    icreal    = 1 if data are real
%    hpfr      high pass frequency
%    cofr      cut-off frequency (=0 -> no)
%
%    gdout     output data
%    frfilt    output frequency filter
%    am1       applyed high pass ARMA filter

% Version 2.0 - February 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=dx_gd(gdin);
hp=hpfr*dt*2;
nhp=round(filtlen*hp);

norm=0;  % standard normalization

am1=crea_am('high',hp);
am1.bilat=1;

spin=gd_pows(gdin,'length',filtlen,'window',2,'nobias')
sp=y_gd(spin);
frfilt=1./sp;
win(1:nhp)=((1-cos(3.1415*(0:nhp-1)/nhp))/2).^2;
frfilt(1:nhp)=frfilt(1:nhp).*win';
frfilt(filtlen:-1:filtlen-nhp+2)=frfilt(filtlen:-1:filtlen-nhp+2).*win(2:nhp)';

if cofr > 0   
    lp=cofr*dt;
    inilp=round(filtlen*lp);
    finlp=min(inilp+100,filtlen/2);
    nlp=finlp-inilp;
    if nlp < 1
        disp(' *** error in cut-off frequency');
    else 
        win=0;
        win(1:nlp)=((1+cos(3.1415*(0:nlp-1)/nlp))/2).^2;
        frfilt(inilp+1:inilp+nlp)=frfilt(inilp+1:inilp+nlp).*win';
        frfilt(filtlen+1-inilp:-1:filtlen+2-finlp)=frfilt(filtlen+1-inilp:-1:filtlen+2-finlp).*win(1:nlp)';
        frfilt(finlp:filtlen+2-finlp)=0;
    end
end

frfilt=create_frfilt(frfilt);
% frfilt=conj(frfilt); % ATTENTION !

switch norm
    case 0
        win=y_gd(am_trfun_nofig(am1,filtlen/2,1));
        su=2*abs(sum(frfilt(1:filtlen/2).*win));
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

yout=am_filter(yout,am1);

gdout=gdin;
gdout=edit_gd(gdout,'y',yout,'addcapt','wiener filtering of:');
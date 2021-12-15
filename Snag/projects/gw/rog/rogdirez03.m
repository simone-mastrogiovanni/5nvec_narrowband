% uso di function f=angr85(bar_ant,source,tsid)
%ANGR85  bar antenna response to a source
%
%   bar_ant   bar antenna structure
%          .long   longitude (degrees)
%          .lat    latitude      "
%          .azim   azimuth       "    (from south to west)
%          .incl   inclination        "
%
%   source
%         .alpha   right ascension
%         .delta   declination
%         .eps     linear polarization percentage
%         .psi     polarization angle
%   
%   tsid     sidereal time (in degrees)
%

bar_ant.long=12.5;
bar_ant.lat=43.;
bar_ant.azim=44;
bar_ant.incl=0;

source.alpha=266;
source.delta=-27;
source.eps=0;
source.psi=0;

%-----------------------

M=1000;
ener=4;
sog=4;
sqrsog=sqrt(sog);
rpat1=zeros(1000,1);
rpat2=rpat1;
tev=(0:999)*pi/500;
ts=(0:999)*12/500;
trpat=sin(tev').^4; size(trpat)
trpat=angr85(bar_ant,source,ts*15)*2; trpat=trpat'; size(trpat)

for i = 1:M
    ev=sqrt(ener*trpat.*(randn(1000,1).^2+randn(1000,1).^2)/2);
    x=(randn(1000,1)+ev);
    y=(randn(1000,1)+ev);
    detect=(sign(x-sqrsog)+1)/2;
    coin=detect.*(sign(y-sqrsog)+1)/2;
    rpat1=rpat1+detect;
    rpat2=rpat2+coin;
end

ndetect=sum(rpat1)/(M*1000)
ncoin=sum(rpat2)/(M*1000)

figure;
rpat1=filter(ones(1,10),1,rpat1);
plot(ts,rpat1); hold on;             % Singolo
rpat2=filter(ones(1,10),1,rpat2);
rpat2=rpat2*sum(rpat1)/sum(rpat2);
plot(ts,rpat2,'r');                  % Coincidenze
trpat=trpat*sum(rpat1)/sum(trpat);
minpat1=min(rpat1(50:1000));
rpat11=rpat1-minpat1;
rpat11=rpat11*sum(rpat1)/sum(rpat11);
rpat11(1:50)=rpat1(1:50);
plot(ts,rpat11,'c');                 % Singolo senza fondo
plot(ts,trpat,'g'); grid on          % Teorico
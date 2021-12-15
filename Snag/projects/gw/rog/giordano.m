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
%         .a       right ascension
%         .d       declination
%         .eps     linear polarization percentage
%         .psi     polarization angle
%   
%   tsid     sidereal time (in degrees)
%

% Simulati M*1000 eventi con distribuzione uniforme nel tempo
% con ampiezza costante o esponenziale o mista
% 
%  evmean   media dell'energia rivelata
%  ndetect  perc eventi rivelati in ciascuna antenna
%  ncoin    perc rivelati in coincidenza
%

%  verde     energy radiation pattern antenna 1
%  celeste   energy radiation pattern antenna 2
%  blu       densita' eventi antenna 1
%  nero      densita' eventi antenna 2
%  rosso     densita' coincidenze

bar_antn.long=12.67;
bar_antn.lat=41.82;
bar_antn.azim=44;
bar_antn.incl=0;

bar_ante.long=6.25;
bar_ante.lat=46.25;
bar_ante.azim=39.3;
bar_ante.incl=0;

% source.a=282.47;
% source.d=-0.76;
source.a=17.7*15;
source.d=-29;
source.eps=0;
source.psi=0;

%-----------------------

set_random

M=5000;
ampev=4.5;
percexp=1;
sog=4.4; % per nois
nois1=1;
nois2=1;
rpat1=zeros(1200,1);
rpat2=rpat1;
rcoin=rpat1;
tev=(0:1199)*pi/600;
ts=(0:1199)*12/600;
trpat1=angr85(bar_antn,source,ts*15); trpat1=trpat1'; 
trpat2=angr85(bar_ante,source,ts*15); trpat2=trpat2';
evmean1=0;
evvar1=0;
evmean2=0;
evvar2=0;

for i = 1:M
    ev=percexp*((randn(1200,1).^2+randn(1200,1).^2)/2)+1-percexp;
    ev1=ampev*sqrt(ev.*trpat1);
    ev2=ampev*sqrt(ev.*trpat2);
    evmean1=evmean1+mean(ev1);
    evvar1=evvar1+var(ev1);
    evmean2=evmean2+mean(ev2);
    evvar2=evvar2+var(ev2);
    x1=(nois1*randn(1200,1)+ev1); % output antenna 1 - n
    x2=(nois2*randn(1200,1)+ev2); % output antenna 2 - e
    detect1=(sign(x1-sog*nois1)+1)/2;
    detect2=(sign(x2-sog*nois2)+1)/2;
    coin=detect1.*detect2;
    rpat1=rpat1+detect1; 
    rpat2=rpat2+detect2;
    rcoin=rcoin+coin;
end

MM=M*1200;

coin24(1:24)=0;

for i = 1:24
    bias=(i-1)*50;
    coin24(i)=sum(rcoin(bias+1:bias+50))/MM;
end

evmean1=evmean1/M
evds1=sqrt(evvar1/M)
evmean2=evmean2/M
evds2=sqrt(evvar2/M)
efficienza_detect1=sum(rpat1)/MM
efficienza_detect2=sum(rpat2)/MM
efficienza_coin=sum(rcoin)/MM

% ftrpat=abs(fft(trpat.^0.5)).*2;
% frpat1=abs(fft(rpat1.^0.5)).*2;
% frpat2=abs(fft(rpat2.^0.5)).*2;


figure;
rpat1=filter(ones(1,10),1,rpat1);
plot(ts,rpat1,'b'); hold on;             % Singolo - n
rpat2=filter(ones(1,10),1,rpat2);
rpat2=rpat2*sum(rpat1)/sum(rpat2);
plot(ts,rpat2,'k'); hold on;             % Singolo - e
rcoin=filter(ones(1,10),1,rcoin);
rcoin=rcoin*sum(rpat1)/sum(rcoin);
plot(ts,rcoin,'r');                  % Coincidenze
trpat1=trpat1*sum(rpat1)/sum(trpat1);
plot(ts,trpat1,'g'); grid on          % Teorico - n
trpat2=trpat2*sum(rpat1)/sum(trpat2);
plot(ts,trpat2,'c'); grid on          % Teorico - e


coin24=coin24;
figure,stairs(0:23,coin24),grid on;
numcoingain=sum(coin24)/max(coin24)

frcoin=fft(rcoin/max(rcoin));
frcoin=frcoin(1:10).*conj(frcoin(1:10));
frcoin=frcoin/max(frcoin)
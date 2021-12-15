function [snrout,dith,y,wien]=test_wiener(datin,nhp,frhp,pulse,ampin,namp,Ntest)
%TEST_WIENER  computes the output SNR for an adaptive wiener filter and a
%             given signal
%
%    datin    input data gd
%    nhp      number of high-pass filters
%    frhp     frequency of high-pass filters
%    pulse    the pulse (double array
%    ampin    maximal input amplitude
%    namp     number of amplitudes
%    Ntest    number of tests
%
%    snrout   output SNR

% Version 2.0 - February 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

% Per definire ampin
%
% $$$$$$$$$$$$$$$$$$$$$$$ - VIRGO - $$$$$$$$$$$$$$$$$$$$$$$$$$$$$
% 
%              measured at frequency resolution [Hz]
%              ____________________________________________
%                                                            From Virgo
% waveform     0.305176 0.152588 0.076294 0.038147 0.019073  EventDump
% ________     ________ ________ ________ ________ ________  ___________
% dfma1b2g1    2.46e-01 2.46e-01 2.46e-01 2.46e-01 2.46e-01  2.47858e-01
% dfma2b4g1    1.78e-01 1.79e-01 1.80e-01 1.80e-01 1.79e-01  1.80866e-01
% gaussian1ms  2.47e-01 2.48e-01 2.48e-01 2.48e-01 2.48e-01  2.48818e-01
% gaussian4ms  8.04e-02 8.08e-02 8.08e-02 8.11e-02 8.08e-02  8.08335e-02
% sgQ15f235    3.54e-01 3.58e-01 3.57e-01 3.57e-01 3.56e-01  3.60017e-01
% sgQ15f820    2.36e-01 2.37e-01 2.37e-01 2.37e-01 2.37e-01  2.37647e-01
% sgQ5f235     3.53e-01 3.55e-01 3.54e-01 3.54e-01 3.54e-01  3.54351e-01
% sgQ5f820     2.38e-01 2.39e-01 2.38e-01 2.38e-01 2.39e-01  2.39135e-01
%                                                                                                       
%                                                                                                       
% %%%%%%%%%%%%%%% - Spiegazione - %%%%%%%%%%%%%%%%%%%%%                                                 
% 
%  Tutti i segnali hanno un hrss = 1e-23.
%                                                                                                       
%  Le SNR corrispondenti sono quelle che da' Shourov.
%  Quindi per avere un snr = 10, per esempio per
%  dfma1b2g1 (sui dati di VIRGO), devi moltiplicare il segnale 
%  per:
%                                                                                                       
%  10/2.46e-01 = 40.16
%                                                                                                       
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


set_random(2);
snrout=(1:namp)*0;

lenpul=length(pulse);
maxevin=max(abs(pulse));
lendat=n_gd(datin);
x=y_gd(datin);
stdevin=std(x(lendat/4:lendat*3/4));
y=(1:lendat)*0;
ind=floor(rand(Ntest,1)*lendat/2+lendat/4);

if nhp > 0
    am1=crea_am('high',100/20000);
    amf=am1;
    for i = 1:nhp-1
        amf=am_multi(amf,am1);
    end
    amf.bilat=1;
     
%     x=y_gd(datin);
%     x=am_filter(x,amf);
%     datin=edit_gd(datin,'y',x);
    datin=am_filter(datin,amf);
end

spin=gd_pows(datin,'pieces',20,'window',2,'nobias');
sp=y_gd(spin);
sp1=mean_every(sp,1,20);
frfiltwi=min(sp1)./sp;
frfiltwi=create_frfilt(frfiltwi);

wien=gd_frfilt(datin,frfiltwi,1);

if nhp > 0
    wien=am_filter(wien,amf);
end
x=y_gd(wien);

y(ind(1)+1:ind(1)+lenpul)=pulse;
if nhp > 0
    y=am_filter(y,amf);
end
y=gd_frfilt(y,frfiltwi,1);
if nhp > 0
    y=am_filter(y,amf);
end
evs=y(ind(i)-lenpul-9:ind(i)+2*lenpul+10);
maxevs=max(abs(evs))
stdev=std(x(lendat/4:lendat*3/4))
gainev=maxevs/maxevin
gainstdev=stdev/stdevin
gainsnr=gainev/gainstdev
%min(ind),max(ind)

for j = 1:namp
    amp=ampin*j/namp;
    a=0;
    q=0;
    for i = 1:Ntest
        y=amp*evs.'+x(ind(i)-lenpul-9:ind(i)+2*lenpul+10);
        a=a+max(abs(y))/stdev;
        q=q+(max(abs(y))/stdev)^2;
    end
    snrout(j)=a/Ntest;
end

dith=snrout*stdev/maxevs;
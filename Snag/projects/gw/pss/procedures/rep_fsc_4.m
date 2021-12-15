%% Report on Fake Source Calibration
% C7 run - 27-2-2007

%% TITLE


% Report on Fake Source Calibration

% In rep_fsc_4

%load fcand_21set

fake_source_file='o:\pss\metadata\FakeSources\sourcefile1.dat';

[fake_source sour]=pss_readsourcefile(fake_source_file,0,80);

% fake_source_file='K:\pss\virgo\pm\sim7\fake100signals_corr.dat';
% 
% fake_source=read_piasourcefile(fake_source_file);

figure
semilogy(fake_source.cand(1,:),fake_source.cand(7,:),'o'),hold on
semilogy(c_cand2(1,:),c_cand2(7,:),'rx'), grid on
title('Fake source found')
xlabel('Hz')
ylabel('amplitude')

figure
plot(fake_source.cand(2,:),fake_source.cand(3,:),'o'),hold on
plot(c_cand2(2,:),c_cand2(3,:),'rx'), grid on
title('Fake source found')
xlabel('lambda')
ylabel('beta')

figure,semilogy(c_cand1(5,:),c_cand2(7,:),'x'),grid on
title('Amplitude analysis of coincidences')
xlabel('detection CR')
ylabel('fake amplitude')

figure,plot(c_cand1(5,:),mod(c_cand1(2,:)-c_cand2(2,:),360),'.'),grid on
title('Detection error')
xlabel('detection CR')
ylabel('lambda error')

figure,plot(c_cand1(5,:),c_cand1(3,:)-c_cand2(3,:),'g.'),grid on
title('Detection error')
xlabel('detection CR')
ylabel('beta error')

figure,plot(c_cand1(5,:),c_cand1(1,:)-c_cand2(1,:),'g.'),grid on
title('Detection error')
xlabel('detection CR')
ylabel('frequency error')

figure,plot(c_cand1(1,:),c_cand1(1,:)-c_cand2(1,:),'x'),grid on
hold on,plot(fake_source.cand(1,:),log(fake_source.cand(7,:))*0.0005+0.002,'ro')
ylim([-.003,.003])
title('Detection error')
xlabel('frequency')
ylabel('frequency error - relative amplitude')

hist(c_cand1(1,:)-c_cand2(1,:),-.01:.00001:0.01); grid on
xlim([-.01,0.01])

%% High CR

i=find(c_cand1(5,:)>15);
c_cand1H=c_cand1(:,i);
c_cand2H=c_cand2(:,i);

figure
semilogy(fake_source.cand(1,:),fake_source.cand(7,:),'o'),hold on
semilogy(c_cand2H(1,:),c_cand2H(7,:),'rx'), grid on
title('Fake source found - High CR')
xlabel('Hz')
ylabel('amplitude')

figure
plot(fake_source.cand(2,:),fake_source.cand(3,:),'o'),hold on
plot(c_cand2H(2,:),c_cand2H(3,:),'rx'), grid on
title('Fake source found - High CR')
xlabel('lambda')
ylabel('beta')

figure,semilogy(c_cand1H(5,:),c_cand2H(7,:),'x'),grid on
title('Amplitude analysis of coincidences - High CR')
xlabel('detection CR')
ylabel('fake amplitude')

figure,plot(c_cand1H(5,:),mod(c_cand1H(2,:)-c_cand2H(2,:),360),'.'),grid on
title('Detection error - High CR')
xlabel('detection CR')
ylabel('lambda error')

figure,plot(c_cand1H(5,:),c_cand1H(3,:)-c_cand2H(3,:),'g.'),grid on
title('Detection error - High CR')
xlabel('detection CR')
ylabel('beta error')

figure,plot(c_cand1H(5,:),c_cand1H(1,:)-c_cand2H(1,:),'g.'),grid on
title('Detection error - High CR')
xlabel('detection CR')
ylabel('frequency error')

figure,plot(c_cand1H(1,:),c_cand1H(1,:)-c_cand2H(1,:),'x'),grid on
hold on,plot(fake_source.cand(1,:),log(fake_source.cand(7,:))*0.0005+0.002,'ro')
ylim([-.003,.003])
title('Detection error - High CR')
xlabel('frequency')
ylabel('frequency error - relative amplitude')

%% Very high CR

i=find(c_cand1(5,:)>22);
c_cand1HH=c_cand1(:,i);
c_cand2HH=c_cand2(:,i);

figure
semilogy(fake_source.cand(1,:),fake_source.cand(7,:),'o'),hold on
semilogy(c_cand2HH(1,:),c_cand2HH(7,:),'rx'), grid on
title('Fake source found - Very high CR')
xlabel('Hz')
ylabel('amplitude')

figure
plot(fake_source.cand(2,:),fake_source.cand(3,:),'o'),hold on
plot(c_cand2HH(2,:),c_cand2HH(3,:),'rx'), grid on
title('Fake source found - Very high CR')
xlabel('lambda')
ylabel('beta')

figure,semilogy(c_cand1HH(5,:),c_cand2HH(7,:),'x'),grid on
title('Amplitude analysis of coincidences - Very high CR')
xlabel('detection CR')
ylabel('fake amplitude')

figure,plot(c_cand1HH(5,:),mod(c_cand1HH(2,:)-c_cand2HH(2,:),360),'.'),grid on
title('Detection error - Very high CR')
xlabel('detection CR')
ylabel('lambda error')

figure,plot(c_cand1HH(5,:),c_cand1HH(3,:)-c_cand2HH(3,:),'g.'),grid on
title('Detection error - Very high CR')
xlabel('detection CR')
ylabel('beta error')

figure,plot(c_cand1HH(5,:),c_cand1HH(1,:)-c_cand2HH(1,:),'g.'),grid on
title('Detection error - Very high CR')
xlabel('detection CR')
ylabel('frequency error')

figure,plot(c_cand1HH(1,:),c_cand1HH(1,:)-c_cand2HH(1,:),'x'),grid on
hold on,plot(fake_source.cand(1,:),log(fake_source.cand(7,:))*0.0005+0.002,'ro')
ylim([-.003,.003])
title('Detection error - Very high CR')
xlabel('frequency')
ylabel('frequency error - relative amplitude')

%% Max CR candidates

[c_cand1A,c_cand2A]=psc_maxcoin(c_cand1,c_cand2);

figure
semilogy(fake_source.cand(1,:),fake_source.cand(7,:),'o'),hold on
semilogy(c_cand2A(1,:),c_cand2A(7,:),'rx'), grid on
title('Fake source found - Max CR')
xlabel('Hz')
ylabel('amplitude')

figure
plot(fake_source.cand(2,:),fake_source.cand(3,:),'o'),hold on
plot(mod(c_cand1A(2,:),360),c_cand1A(3,:),'rx'), grid on
title('Fake source found - Max CR')
xlabel('lambda')
ylabel('beta')

figure,semilogy(c_cand1A(5,:),c_cand2A(7,:),'x'),grid on
title('Amplitude analysis of coincidences - Max CR')
xlabel('detection CR')
ylabel('fake amplitude')

figure,plot(c_cand1A(5,:),mod(c_cand1A(2,:)-c_cand2A(2,:),360),'.'),grid on
title('Detection error - Max CR')
xlabel('detection CR')
ylabel('lambda error')

figure,plot(c_cand1A(5,:),c_cand1A(3,:)-c_cand2A(3,:),'g.'),grid on
title('Detection error - Max CR')
xlabel('detection CR')
ylabel('beta error')

figure,plot(c_cand1A(5,:),c_cand1A(1,:)-c_cand2A(1,:),'g.'),grid on
title('Detection error - Max CR')
xlabel('detection CR')
ylabel('frequency error')

figure,plot(c_cand1A(1,:),c_cand1A(1,:)-c_cand2A(1,:),'x'),grid on
hold on,plot(fake_source.cand(1,:),log(fake_source.cand(7,:))*0.0005+0.002,'ro')
ylim([-.003,.003])
title('Detection error - Max CR')
xlabel('frequency')
ylabel('frequency error - relative amplitude')

%% psc_faketable program

psc_faketable(c_cand1,c_cand2,fake_source.cand);

%% Report on Resampling Procedure - 2
% SF - 12-2-2007

%% TITLE


% Report on Resampling Procedure - 2

% In rep_res_2

%% Creates a gd (a data object) with a white gaussian noise

fr0=20000;
N0=fr0*10;
N1=N0/10;
gin=gd_noise('amp',1,'len',N0,'dt',1/fr0)

%% Low-pass the original data (band 0-2000 Hz)

g=y_gd(gin);
g=fft(g);
g(N1+1:N0)=0;
g(N1-9:N1)=g(N1-9:N1).*(10:-1:1)'/10;
g(N0:-1:N0-N1+2)=conj(g(2:N1));
g=ifft(g);
gin1=gin;
gin1=edit_gd(gin1,'y',g,'capt','low-pass original data');

%% Resamples the data at 4000 Hz
%
% The 200000 data are divided in pieces of 2 s (40000 data each). The
% junction is every 2 s.

gout4000=gd_resampling(gin1,1/4000,2^15)


%% Resamples the data at 4096 Hz
%
% The 200000 data are divided in pieces of 2 s (40000 data each). The
% junction is every 2 s.

gout4096=gd_resampling(gin1,1/4096,2^15)
figure,plot(gin1,'g',gout4000,'bo',gout4096,'r+');grid on
xlim([1.995 2.005])
xlabel('seconds')
title('original low-pass, 4000 Hz (blue o) and 4096 data (red +)')

%% Power spectra
%

sout4000=gd_pows(gout4000,'window',2,'short')
sout4096=gd_pows(gout4096,'window',2,'short')
sin1=gd_pows(gin1,'window',2,'short')

figure,semilogy(sin1,'g',sout4096,'r',sout4000,'b');grid on
xlabel('Hz')
title('Power spectra: original low-pass, 4000 Hz (blue) and 4096 data (red)')

figure,semilogy(sin1,'g',sout4096,'r',sout4000,'b');grid on
xlim([1985 2010])
ylim([1e-9 1e-3])
xlabel('Hz')
title('Power spectra: original low-pass, 4000 Hz (blue) and 4096 data (red)')

%% Resamples the data 4096 Hz at 4000 Hz and take the difference
%

gout4096a=gd_resampling(gout4096,1/4000,2^11)
dif=gout4096a-gout4000
figure,plot(dif),grid on

title('Difference of 4 kHz and 4096 Hz data res. at 4kHz')
xlabel('s')
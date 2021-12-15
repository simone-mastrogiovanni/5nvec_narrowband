%% Report on Resampling Procedure
% SF - 9-2-2007

%% TITLE


% Report on Resampling Procedure

% In rep_res_1

% The gd_resampling function

type gd_resampling.m

%% Creates a gd (a data object) with a sinusoidal signal

gin=gd_sin('amp',1,'freq',300.2341,'phase',40,'len',40000,'dt',1/4000)

%% Resamples the data at 4096 Hz
%
% The 40000 data are divided in pieces of 2 s (8000 data each). The
% junction is every 2 s.

gout=gd_resampling(gin,1/4096,2^12)

figure,plot(gin,'--o',gout,'r+');grid on
xlim([1.99 2.01])
xlabel('seconds')
title('original (blue o) and resampled data (red +)')

%% Resamples the 4096 Hz data back to 4000 Hz

gin1=gd_resampling(gout,1/4000,2^12)

figure,plot(gin,'--o',gin1,'r+');grid on
xlim([1.99 2.01])
xlabel('seconds')
title('original (blue o) and bi-resampled data (red +)')

gindif=gin-gin1

figure,plot(gindif);
xlabel('seconds')
title('original (blue x) and bi-resampled data (red +)')

%% Difference analysis

sdif=gd_pows(gindif,'window',2,'short')

figure,semilogy(sdif);grid on
ylim([1e-15 1e-8]),xlim([0 2000])
xlabel('Hz')
title('Power spectrum of the error')

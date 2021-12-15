% ana_peakmap_basic

tic
% Dfr=5; % EDIT
Dfr=10; % EDIT
% VSR='VSR4'; % EDIT
VSR='O1H_2048Hz'; % EDIT

% h2=0  % for Virgo
% h2=[62 1000 -7/24]   %  for Livingston
% h2=[62 1000 -9/24] %  for Hanford

% hpar=[12 0.01 -7/24]   %  for Livingston
hpar=[12 0.01 -9/24] %  for Hanford

%for i = 17:26  % EDIT
for i = 2:102  % EDIT
    band=[(i-1) i]*Dfr;
    strtit=sprintf(' %s  band %4.1f - %4.1f',VSR,band)
    savestr=sprintf('PMH_%s_%03d_%03d',VSR,band);
    eval(['[A tim vel]=read_peakmap0(''list_' VSR '_pm.txt'',band,0,0);'])
%     eval(['[x y v ' savestr ']=plot_peaks(A,1,h2,1,strtit);'])
    eval([savestr '=hist_peaks(A,hpar);'])
    eval(['save(''' savestr ''',''' savestr ''');'])
    toc
end
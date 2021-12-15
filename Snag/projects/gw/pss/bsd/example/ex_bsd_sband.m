% ex_bsd_sband
%
% extracts a band around the pulsar_3 
%
% other developments: ex_bsd_dedop

tic

pp=pulsar_3;  %  not updated sources !
fr=pp.f0;
dfr=0.1;

[bsd_outL,BSD_tab_outL,outL]=bsd_access('I:','ligol','O1',[57270 57570],[fr-dfr fr+dfr],2);
[bsd_outH,BSD_tab_outH,outH]=bsd_access('I:','ligoh','O1',[57270 57570],[fr-dfr fr+dfr],2);

toc
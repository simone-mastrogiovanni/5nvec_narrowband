% Orn_info_cand_1

ant='L'
ant='H'
run='O2A'
fil='check_0410_O2B_L';
fil='check_0410_O2A_H';
nbands=1;
jo=410;

load(fil)
% jo=jobinf(:,2);
bands=unique(jo);
nbands=length(bands);

eval([ant '_' run '_' num2str(jo) '_cand=cand;'])

pteor_=hough_peak_prob(0,2.5,0.01);
i=1;

% for i = 1:nbands
%     ii=find(candtot(1,:) >= bands(i) & candtot(1,:) < bands(i)+10);
%     cand=candtot(:,ii);
    peakfil=sprintf('peaks_%04d_%s_%s.mat',bands(i),run,ant);
    load(peakfil);
    lfft(i)=job_info_s.par.lfft;
    dfr(i)=job_info_s.par.dfr0;
    dsd(i)=job_info_s.par.dsd0;
    Npi=length(peaks_info);
    npeaks=[peaks_info.npeaks];
    Nfft(i)=length(npeaks);
    iii=find(npeaks <= 0);
    Nzerofft(i)=length(iii);
    Npeaks(i)=sum(npeaks);
    Npeaksteo(i)=(Nfft(i)-Nzerofft(i))*lfft(i)*pteor_;
    Ncands(i)=length(cand);
%     eval([ant '_cand{' num2str(i) '}=cand;'])
% end

lfft=lfft(:);
dfr=dfr(:);
dsd=dsd(:);
Nfft=Nfft(:);
Nzerofft=Nzerofft(:);
Nfft1=Nfft-Nzerofft;
Npeaks=Npeaks(:);
Npeaksteo=Npeaksteo(:);
Ncands=Ncands(:);

eval([ant '_' run '_' num2str(jo) '_cand_tab=table(bands,lfft,Nfft,Nzerofft,dfr,dsd,Npeaks,Npeaksteo,Ncands)'])

clear cand_str
eval(['cand_str.cand=' ant '_' run '_' num2str(jo) '_cand;'])
eval(['cand_str.tab=' ant '_' run '_' num2str(jo) '_cand_tab;'])
eval(['cand_str.epoch=job_info_s.epoch;'])
eval([ant '_' run '_' num2str(jo) '_cand=cand_str;'])
eval(['save(''' ant '_' run '_' num2str(jo) '_cand'',''' ant '_' run '_' num2str(jo) '_cand'');'])


% figure,plot(bands,Npeaks),grid on,hold on,plot(bands,Npeaks,'r.'),title('Npeaks'),xlabel('bands')
% figure,plot(bands,Nzerofft),grid on,hold on,plot(bands,Nzerofft,'r.'),title('Nzerofft'),xlabel('bands')
% figure,plot(bands,Ncands),grid on,hold on,plot(bands,Ncands,'r.'),title('Ncands'),xlabel('bands')
% 
% figure,semilogy(bands,lfft),grid on,hold on,semilogy(bands,lfft,'r.'),title('lfft'),xlabel('bands')
% figure,semilogy(bands,Nfft),grid on,hold on,semilogy(bands,Nfft,'r.'),title('Nfft'),xlabel('bands')
% figure,semilogy(bands,dfr),grid on,hold on,semilogy(bands,dfr,'r.'),title('dfr'),xlabel('bands')
% figure,semilogy(bands,dsd),grid on,hold on,semilogy(bands,dsd,'r.'),title('dsd'),xlabel('bands')
% 
% psper_=sum(Npeaks)/sum(lfft.*Nfft/2);
% psper1_=sum(Npeaks)/sum(lfft.*Nfft1/2);
% 
% figure
% for i = 1:nbands
%     eval(['cands=' ant '_cand{' num2str(i) '};'])
%     Ana_band(i).psper1=Npeaks(i)/(lfft(i).*Nfft1(i)/2);
%     Ana_band(i).mucand=mean(cands(5,:));
%     Ana_band(i).musper=Nfft1(i)*Ana_band(i).psper1;
%     Ana_band(i).muteor=Nfft1(i)*pteor_;
%     Ana_band(i).sigteor=sqrt(Nfft(i)*Ana_band(i).psper1*(1-Ana_band(i).psper1));
%     [Ana_band(i).hist,Ana_band(i).xh]=hist((cands(5,:)-Ana_band(i).muteor)/Ana_band(i).sigteor,100);
%     Ana_band(i).Hist=cumsum(Ana_band(i).hist(end:-1:1));
%     Ana_band(i).Hist=Ana_band(i).Hist(end:-1:1)/Ana_band(i).Hist(end);
% %     semilogy(Ana_band(i).xh,Ana_band(i).Hist),hold on
%     semilogy(Ana_band(i).xh,Ana_band(i).Hist),grid on,title(num2str(bands(i))),pause(0.5),hold on
% end
% 
% grid on
% Orn_crea_candin

% ant='L'
ant='H'
run='O2'
fil='candinfo_full_O2_L';
fil='candinfo_full_O2_H';
nbands=70;

load(fil)
jo=jobinf(:,2);
bands=unique(jo);
nbands=length(bands);

pteor_=hough_peak_prob(0,2.5,0.01);

for i = 1:nbands
    ii=find(candtot(1,:) >= bands(i) & candtot(1,:) < bands(i)+10);
    cand=candtot(:,ii);
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
    Ncands(i)=length(ii);
%     eval([ant '_cands{' num2str(i) '}=cand;'])
end

lfft=lfft(:);
dfr=dfr(:);
dsd=dsd(:);
Nfft=Nfft(:);
Nzerofft=Nzerofft(:);
Nfft1=Nfft-Nzerofft;
Npeaks=Npeaks(:);
Npeaksteo=Npeaksteo(:);
Ncands=Ncands(:);

cand_tab=table(bands,lfft,Nfft,Nzerofft,dfr,dsd,Npeaks,Npeaksteo,Ncands);

eval([ant '_cand.cand=candtot;'])
eval([ant '_cand.tab=cand_tab;'])

eval(['save(''' ant '_cand'',''' ant '_cand'');'])
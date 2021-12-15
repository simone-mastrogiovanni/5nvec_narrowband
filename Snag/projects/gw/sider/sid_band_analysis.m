function [outstr hand]=sid_band_analysis(g2in,subband,ant,gencapt,nofig,nbin)
% sid_band_analysis 
%
%    subband   [frmin frmax]; 0 -> all
%    nofig     > 0 no figures
%              = 2 no phfr_spec2
%
%    outstr.

if ~exist('nofig','var')
    nofig=0;
end

if ~exist('nbin','var')
    nbin=100;
end

if isfield(ant,'inifr')
    outstr.inifr=ant.inifr;
else
    outstr.inifr=0;
end

ihand=0;

gencapt1=underscore_man(gencapt);

capt.spec.title='spectral density';
capt.spec.xlabel='Hz';
capt.spec.ylabel='h/sqrt(Hz)';
capt.amp.title='periodicity amplitude';
capt.amp.xlabel='Hz';
capt.amp.ylabel='fraction of the mean value';
capt.phase.title='phase of the maximum';
capt.phase.xlabel='Hz';
capt.phase.ylabel='hours';
capt.aphase.title='phase of the minimum';
capt.aphase.xlabel='Hz';
capt.aphase.ylabel='hours';
capt.epfold.title='epoch folding with smoothing';
capt.epfold.xlabel='hours';
capt.epfold.ylabel='fraction of the mean value';

[periods outstr.percleans win outstr.perpars outstr.meanpers]=gd2_period(g2in,'sid',ant,nbin,subband,1);
ccapt=sprintf(' band %4.0f-%4.0f ',min(outstr.perpars(1,:)),max(outstr.perpars(1,:)));

if nofig <= 0
    [g2st gmean gstd]=gd2_stat(g2in,300,0,1,{[gencapt ccapt] 'Frequency (Hz)'});
    figure,logplot_gd2(g2in,80,'.'),grid on
    title([gencapt ccapt ' - subbands']);
    xlabel('days')
    ihand=ihand+2;
    hand(ihand)=gcf;
end


[periods outstr.percleans win outstr.perpars outstr.meanpers]=gd2_period(g2in,'sid',ant,nbin,subband,nofig);

if nofig <= 0
%     if max(outstr.perpars(2,:))/min(outstr.perpars(2,:)) < 10
%         figure,plot(outstr.perpars(1,:),outstr.perpars(2,:)),grid on
%     else
%         figure,semilogy(outstr.perpars(1,:),outstr.perpars(2,:)),grid on
%     end
%     title([capt.spec.title ccapt]),xlabel(capt.spec.xlabel),ylabel(capt.spec.ylabel)
%     xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]);

    figure,plot(outstr.meanpers(1,:),outstr.meanpers(2,:)),hold on,plot(outstr.meanpers(1,:),outstr.meanpers(3,:),'r'),grid on
    title([gencapt1 ccapt ' - Sidereal ' capt.epfold.title]),xlabel(capt.epfold.xlabel),ylabel(capt.epfold.ylabel)
    xlim([min(outstr.meanpers(1,:)) max(outstr.meanpers(1,:))]);
    ihand=ihand+1;
    hand(ihand)=gcf;
end

[periodd outstr.percleand win outstr.perpard outstr.meanperd]=gd2_period(g2in,'day',0,nbin,subband,nofig);

if nofig <= 0
    ihand=ihand+1;
    hand(ihand)=gcf;
    figure,plot(outstr.meanperd(1,:),outstr.meanperd(2,:)),hold on,plot(outstr.meanperd(1,:),outstr.meanperd(3,:),'r'),grid on
    title([gencapt1 ccapt ' - Solar ' capt.epfold.title]),xlabel(capt.epfold.xlabel),ylabel(capt.epfold.ylabel)
    xlim([min(outstr.meanperd(1,:)) max(outstr.meanperd(1,:))]);
    ihand=ihand+1;
    hand(ihand)=gcf;
    
    figure,plot(outstr.perpars(1,:),outstr.perpars(3,:)),grid on,hold on,...
        plot(outstr.perpard(1,:),outstr.perpard(3,:),'r'),xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]),...
        title([gencapt1 ccapt ' - ' capt.amp.title ' (red solar)']),xlabel(capt.amp.xlabel),ylabel(capt.amp.ylabel);
    ihand=ihand+1;
    hand(ihand)=gcf;
    
    figure,plot(outstr.perpars(1,:),outstr.perpars(4,:),'.'),grid on,hold on,...
        plot(outstr.perpard(1,:),outstr.perpard(4,:),'r.'),xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]),...
        title([gencapt1 ccapt ' - ' capt.phase.title ' (red solar)']),xlabel(capt.phase.xlabel),ylabel(capt.phase.ylabel);
    ihand=ihand+1;
    hand(ihand)=gcf;
end

[perioda outstr.percleana win outstr.perpara outstr.meanpera]=gd2_period(g2in,'asid',ant,nbin,subband,nofig);
ihand=ihand+1;
hand(ihand)=gcf;

if nofig <= 0
    figure,plot(outstr.meanpera(1,:),outstr.meanpera(2,:)),hold on,plot(outstr.meanpera(1,:),outstr.meanpera(3,:),'r'),grid on
    title([gencapt1 ccapt ' - Anti-Sidereal ' capt.epfold.title]),xlabel(capt.epfold.xlabel),ylabel(capt.epfold.ylabel)
    xlim([min(outstr.meanpera(1,:)) max(outstr.meanpera(1,:))]);
    ihand=ihand+1;
    hand(ihand)=gcf;
        
    figure,plot(outstr.perpars(1,:),outstr.perpars(3,:)),grid on,hold on,...
        plot(outstr.perpara(1,:),outstr.perpara(3,:),'g'),xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]),...
        title([gencapt1 ccapt ' - ' capt.amp.title ' (green antisid)']),xlabel(capt.amp.xlabel),ylabel(capt.amp.ylabel);
    ihand=ihand+1;
    hand(ihand)=gcf;
    
    figure,plot(outstr.perpars(1,:),outstr.perpars(4,:),'.'),grid on,hold on,...
        plot(outstr.perpara(1,:),outstr.perpara(4,:),'g.'),xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]),...
        title([gencapt1 ccapt ' - ' capt.phase.title ' (green antisid)']),xlabel(capt.phase.xlabel),ylabel(capt.phase.ylabel);
    ihand=ihand+1;
    hand(ihand)=gcf;
end

[periodw outstr.percleanw win outstr.perparw outstr.meanperw]=gd2_period(g2in,'week',0,168,subband,nofig);

if nofig <= 0
    ihand=ihand+1;
    hand(ihand)=gcf;
    figure,plot(outstr.meanperw(1,:),outstr.meanperw(2,:)),hold on,plot(outstr.meanperw(1,:),outstr.meanperw(3,:),'r'),grid on
    title([gencapt1 ccapt ' - Week ' capt.epfold.title]),xlabel('week''s days'),ylabel(capt.epfold.ylabel)
    xlim([min(outstr.meanperw(1,:)) max(outstr.meanperw(1,:))]);
    ihand=ihand+1;
    hand(ihand)=gcf;
    
%     figure,plot(outstr.perpars(1,:),outstr.perpars(3,:)),grid on,hold on,...
%         plot(outstr.perpar(1,:),outstr.perpar(3,:),'r'),xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]),...
%         title([gencapt1 ccapt ' - ' capt.amp.title ' (red solar)']),xlabel(capt.amp.xlabel),ylabel(capt.amp.ylabel);
%     
%     figure,plot(outstr.perpars(1,:),outstr.perpars(4,:)),grid on,hold on,...
%         plot(outstr.perpar(1,:),outstr.perpar(4,:),'r'),xlim([min(outstr.perpars(1,:)) max(outstr.perpars(1,:))]),...
%         title([gencapt1 ccapt ' - ' capt.phase.title ' (red solar)']),xlabel(capt.phase.xlabel),ylabel(capt.phase.ylabel);
end


if nofig < 2
    [outstr.g2 map outstr.asp]=phfr_spec2(g2in,60,[gencapt ccapt],subband,nbin,2);
    ihand=ihand+1;
    hand(ihand)=gcf;
end

[outstr.ps psls outstr.psef]=fullband_anagd2(g2in,0,[0 3.1],12,[1 0 0],[gencapt ccapt]);
    ihand=ihand+1;
    hand(ihand)=gcf;
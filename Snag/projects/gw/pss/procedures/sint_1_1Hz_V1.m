% sint_1_1Hz_V1
%
% uses matlab files like 1Hz_raw_100903 in Raw_VSR2
%
% quadratic spectra (after 100915)

typ=1 % all
% typ=2 % good
% typ=3 % bad

clear fr
clear hvirnois
clear hnois
clear rapmax
clear rapstd
clear Hsol
clear Hsid
clear meaper
clear snreff
clear heff
clear sidres
clear solres

% phcorr=181.1214478/15 % ATTENTION
switch typ
    case 1
        mifr=1;
        fr=[6 12 22 31 40 45 74 93 108 122 192 290 353 403 575 664 917 1166 1897];
    case 2
        mifr=10;
        fr=[11 12 14 22 24 25 31 40 52 74 108 122 192 290 353 403 575 664 917 1166 1897];
    case 3
        mifr=10;
        fr=[18 45 50 334];
end

load SensitivityH_VSR1_05Sep2007

n=length(fr);
mafr=ceil(max(fr)/100)*100;

for i = 1:n
    str1=sprintf('%04d',fr(i));
    eval(['par=par' str1 ';']);
    eval(['tsid=tsid' str1 ';']);
    eval(['tsol=tsol' str1 ';']);
    eval(['sp1=sp1' str1 ';']);
    hvirnois(i)=gd_value(sens,fr(i));
    rapmax(i)=par.asidmax/par.asolmax;
    rapstd(i)=par.asidstd/par.asolstd;
    Hsol(i)=par.hsol;
%     Hsid(i)=mod(phcorr+par.hsid,24);
    Hsid(i)=par.hsid;
    meaper(i)=mean(tsid.fit);
    hnois(i)=1e-20*meaper(i)/sqrt(par.band(2)-par.band(1));
    snreff(i)=par.asidmax/(meaper(i));
    heff(i)=par.asidmax*hvirnois(i)/(meaper(i));
    sidres(i)=std(tsid.base-tsid.fit)./par.asidmax;
    solres(i)=std(tsol.base-tsol.fit)./par.asolmax;
    if i == 1
        tsolfit=tsol.fit*0;
        tsidfit=tsid.fit*0;
        tsolbas=tsolfit;
        tsidbas=tsidfit;
        lfspec=sp1*0;
    end
    tsolfit=tsolfit+tsol.fit/(meaper(i)*n);
    tsidfit=tsidfit+tsid.fit/(meaper(i)*n);
    tsolbas=tsolbas+tsol.base/(meaper(i)*n);
    tsidbas=tsidbas+tsid.base/(meaper(i)*n);%i,lfspec,sp1
    lfspec=lfspec+sp1/(meaper(i)*n).^2;
end

% rap
figure,semilogx(fr,rapmax),grid on,hold on,semilogx(fr,rapmax,'r.'),semilogx(fr,rapstd,'r'),semilogx(fr,rapstd,'.')
title('Significance Tsid/Tsol for max (red) and std (blue)'),xlabel('Hz'),xlim([mifr mafr])

% if typ == 1
%     ma=max(max(rapmax),max(rapstd));
%     bar=334;
%     plot([bar bar],[0 ma],'m--')
%     bar=50;
%     plot([bar bar],[0 ma],'m--')
%     bar=45;
%     plot([bar bar],[0 ma],'m--')
%     bar=18;
%     plot([bar bar],[0 ma],'m--')
% end

% hvirnois,heff
figure,loglog(fr,hvirnois),grid on,hold on,loglog(fr,hvirnois,'r.'),loglog(fr,heff,'r'),loglog(fr,heff,'b.')
title('Virgo nominal noise (blue) and sidereal part (red)'),xlabel('Hz'),xlim([mifr mafr])

% if typ == 1
%     ma=max(max(hvirnois),max(heff));
%     mi=min(min(hvirnois),min(heff));
%     bar=334;
%     plot([bar bar],[mi ma],'m--')
%     bar=50;
%     plot([bar bar],[mi ma],'m--')
%     bar=45;
%     plot([bar bar],[mi ma],'m--')
%     bar=18;
%     plot([bar bar],[mi ma],'m--')   
% end

% hnois
figure,loglog(fr,hnois),grid on,hold on,loglog(fr,hnois,'r.'),loglog(fr,snreff.*hnois,'r'),loglog(fr,snreff.*hnois,'b.')
title('Band noise (blue) and sidereal part (red)'),xlabel('Hz'),xlim([mifr mafr])

% if typ == 1
%     ma=max(max(hnois),max(snreff.*hnois));
%     mi=min(min(hnois),min(snreff.*hnois));
%     bar=334;
%     plot([bar bar],[mi ma],'m--')
%     bar=50;
%     plot([bar bar],[mi ma],'m--')
%     bar=45;
%     plot([bar bar],[mi ma],'m--')
%     bar=18;
%     plot([bar bar],[mi ma],'m--')   
% end

% snreff
figure,loglog(fr,snreff),grid on,hold on,loglog(fr,snreff,'r.')
title('Fraction of the sidereal part'),xlabel('Hz'),xlim([mifr mafr])

% if typ == 1
%     ma=max(snreff);
%     mi=min(snreff),min(heff);
%     bar=334;
%     plot([bar bar],[mi ma],'m--')
%     bar=50;
%     plot([bar bar],[mi ma],'m--')
%     bar=45;
%     plot([bar bar],[mi ma],'m--')
%     bar=18;
%     plot([bar bar],[mi ma],'m--')   
% end

% hour
figure,semilogx(fr,Hsol,'g'),grid on,hold on,semilogx(fr,Hsol,'m.'),semilogx(fr,Hsid,'r'),semilogx(fr,Hsid,'b.')
title('Sidereal hours of the peak (solar in greeen)'),xlabel('Hz'),xlim([mifr mafr]),ylim([0 24])

% if typ == 1
%     ma=max(max(Hsol),max(Hsid));
%     bar=334;
%     plot([bar bar],[0 ma],'m--')
%     bar=50;
%     plot([bar bar],[0 ma],'m--')
%     bar=45;
%     plot([bar bar],[0 ma],'m--')
%     bar=18;
%     plot([bar bar],[0 ma],'m--')
% end

% res
figure,semilogx(fr,solres,'g'),grid on,hold on,semilogx(fr,solres,'m.'),semilogx(fr,sidres,'r'),semilogx(fr,sidres,'b.')
title('Sidereal period residuals (solar in greeen)'),xlabel('Hz'),xlim([mifr mafr])

% if typ == 1
%     ma=max(max(solres),max(sidres));
%     bar=334;
%     plot([bar bar],[0 ma],'m--')
%     bar=50;
%     plot([bar bar],[0 ma],'m--')
%     bar=45;
%     plot([bar bar],[0 ma],'m--')
%     bar=18;
%     plot([bar bar],[0 ma],'m--')
% end

figure,show_phase_diagram(tsolbas,15),hold on,show_phase_diagram(tsolfit,15,'r')
title('Solar periodicity')
figure,show_phase_diagram(tsidbas,15),hold on,show_phase_diagram(tsidfit,15,'r')
title('Sidereal periodicity')
ma=max(x_gd(lfspec));
show_spec_lines(lfspec)

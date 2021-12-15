% sint_3_1Hz
%
% uses matlab files like 1Hz_raw_100903 in Raw_VSR2

jj=2
str3=sprintf('%1d',jj);
str4=sprintf('Sub-period %d - ',jj);
typ=1 % all
% typ=2 % good
% typ=3 % bad

clear fr
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
        fr=[0 1 2 3 4 5 6 11 12 14 18 22 24 25 31 40 45 50 52 74 108 122 192 290 334 353 403 575 664 917 1166 1897];
    case 2
        fr=[0 1 2 3 4 5 6 11 12 14 22 24 25 31 40 52 74 108 122 192 290 353 403 575 664 917 1166 1897];
    case 3
        fr=[18 45 50 334];
end

load SensitivityH_VSR2_091020

n=length(fr);

for i = 1:n
    str1=sprintf('%04d',fr(i));
    eval(['par=par' str1 '{' str3 '};']);
    eval(['tsid=tsid' str1 '{' str3 '};']);
    eval(['tsol=tsol' str1 '{' str3 '};']);
    eval(['sp1=sp1' str1 '{' str3 '};']);
    hnois(i)=gd_value(sens,fr(i));
    rapmax(i)=par.asidmax/par.asolmax;
    rapstd(i)=par.asidstd/par.asolstd;
    Hsol(i)=par.hsol;
%     Hsid(i)=mod(phcorr+par.hsid,24);
    Hsid(i)=par.hsid;
    meaper(i)=mean(tsid.fit);
    snreff(i)=par.asidmax/(2*meaper(i));
    heff(i)=par.asidmax*hnois(i)/(2*meaper(i));
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
    tsidbas=tsidbas+tsid.base/(meaper(i)*n);
    lfspec=lfspec+sp1/(meaper(i)*n);
end

% rap
figure,semilogx(fr,rapmax),grid on,hold on,semilogx(fr,rapmax,'r.'),semilogx(fr,rapstd,'r'),semilogx(fr,rapstd,'.')
title([str4 'Significance Tsid/Tsol for max (red) and std (blue)'])

if typ == 1
    ma=max(max(rapmax),max(rapstd));
    bar=334;
    plot([bar bar],[0 ma],'m--')
    bar=50;
    plot([bar bar],[0 ma],'m--')
    bar=45;
    plot([bar bar],[0 ma],'m--')
    bar=18;
    plot([bar bar],[0 ma],'m--')
end

% hnois,heff
figure,loglog(fr,hnois),grid on,hold on,loglog(fr,hnois,'r.'),loglog(fr,heff,'r'),loglog(fr,heff,'b.')
title([str4 'Virgo noise (blue) and sidereal part (red)'])

if typ == 1
    ma=max(max(hnois),max(heff));
    mi=min(min(hnois),min(heff));
    bar=334;
    plot([bar bar],[mi ma],'m--')
    bar=50;
    plot([bar bar],[mi ma],'m--')
    bar=45;
    plot([bar bar],[mi ma],'m--')
    bar=18;
    plot([bar bar],[mi ma],'m--')   
end

% snreff
figure,loglog(fr,snreff),grid on,hold on,loglog(fr,snreff,'r.')
title([str4 'Fraction of the sidereal part'])

if typ == 1
    ma=max(snreff);
    mi=min(snreff),min(heff);
    bar=334;
    plot([bar bar],[mi ma],'m--')
    bar=50;
    plot([bar bar],[mi ma],'m--')
    bar=45;
    plot([bar bar],[mi ma],'m--')
    bar=18;
    plot([bar bar],[mi ma],'m--')   
end

% hour
figure,semilogx(fr,Hsol,'g'),grid on,hold on,semilogx(fr,Hsol,'m.'),semilogx(fr,Hsid,'r'),semilogx(fr,Hsid,'b.')
title([str4 'Sidereal hours of the peak (solar in greeen)'])

if typ == 1
    ma=max(max(Hsol),max(Hsid));
    bar=334;
    plot([bar bar],[0 ma],'m--')
    bar=50;
    plot([bar bar],[0 ma],'m--')
    bar=45;
    plot([bar bar],[0 ma],'m--')
    bar=18;
    plot([bar bar],[0 ma],'m--')
end

% res
figure,semilogx(fr,solres,'g'),grid on,hold on,semilogx(fr,solres,'m.'),semilogx(fr,sidres,'r'),semilogx(fr,sidres,'b.')
title([str4 'Sidereal period residuals (solar in greeen)'])

if typ == 1
    ma=max(max(solres),max(sidres));
    bar=334;
    plot([bar bar],[0 ma],'m--')
    bar=50;
    plot([bar bar],[0 ma],'m--')
    bar=45;
    plot([bar bar],[0 ma],'m--')
    bar=18;
    plot([bar bar],[0 ma],'m--')
end

figure,show_phase_diagram(tsolbas,15),hold on,show_phase_diagram(tsolfit,15,'r')
title([str4 'Solar periodicity'])
figure,show_phase_diagram(tsidbas,15),hold on,show_phase_diagram(tsidfit,15,'r')
title([str4 'Sidereal periodicity'])
show_spec_lines(lfspec),title([str4 'Low frequency pseudo-spectrum'])
figure,plot(lfspec),title([str4 'Low frequency pseudo-spectrum'])

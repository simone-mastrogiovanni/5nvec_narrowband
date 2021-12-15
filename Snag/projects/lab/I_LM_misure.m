% I_LM_misure

answ=inputdlg({'Numero misure' 'Valore vero' 'Errore di lettura' ...
    'Errore sistematico (alfa)' 'Errore sistematico (beta)' ...
    'Errore casuale' 'Trend' 'Probabilità disturbi' 'Ampiezza disturbi'},...
    'Risultati di misure ripetute',...
    1,{'60' '10' '0.1' '0.2' '0.01' '0.4' '0.01' '0.04' '3'});

Nmis=eval(answ{1});
valv=eval(answ{2});
errlet=eval(answ{3});
esalf=eval(answ{4});
esbet=eval(answ{5});
errcas=eval(answ{6});
trend=eval(answ{7});
pr_dist=eval(answ{8});
amp_dist=eval(answ{9});

[mis el es ec tr dist]=LM_misure([valv Nmis],errlet,[esbet esalf],errcas,trend,pr_dist,amp_dist);

figure,plot(mis),hold on,plot(mis,'r.'),grid on
title('Misure ripetute'),xlabel('Numero d''ordine')
figure,plot(el),hold on,plot(es,'r'),plot(ec,'k'),grid on
plot(el,'.'),plot(es,'r.'),plot(ec,'k.')
title('Errori'),xlabel('Numero d''ordine'),legend('Errori di lettura','Errore sistematico','Errori casuali')
figure,plot(tr),hold on,plot(dist,'k'),grid on
plot(tr,'.'),plot(dist,'k.')
title('Disturbi e trend'),xlabel('Numero d''ordine'),legend('Trend','Disturbi')

mea=mean(mis);
sd=std(mis);
msgbox({sprintf('media = %f',mea) sprintf('st.dev. = %f',sd)},'Statistica Misure')

figure,hist(mis,100),title('Istogramma delle misure')
figure,hist(el,round(sqrt(Nmis))),title('Istogramma errori di lettura')
figure,hist(ec,round(sqrt(Nmis))),title('Istogramma errori casuali')
figure,hist(es,round(sqrt(Nmis))),title('Istogramma errori sistematici')

timstr=snag_timestr(now);
fid=fopen(['misure_' timstr '.dat'],'w');
fprintf(fid,'               Simulazione di misure  \r\n\r\n');
fprintf(fid,'    Errore di lettura   %f  \r\n',errlet);
fprintf(fid,'    Errore casuale      %f  \r\n',errcas);
fprintf(fid,'    Errore sistematico alfa e beta  %f  %f \r\n',esalf,esbet);
fprintf(fid,'    Trend               %f  \r\n',trend);
fprintf(fid,'    Disturbo (prob,amp) %f   %f\r\n',pr_dist,amp_dist);
fprintf(fid,'\r\n N           misura    err.lett.   err.cas.    err.sist.     trend     disturbo  \r\n');

if errlet > 0
    ndig=ceil(log10(1/errlet));
else
    ndig=6;
end
format=sprintf('%%4d   %%12.%df  %%10f  %%10f  %%10f  %%10f  %%10f  \r\n',ndig);

for i = 1:Nmis
    fprintf(fid,format,i,mis(i),el(i),ec(i),es(i),tr(i),dist(i));
end

fprintf(fid,'\r\n    media  %f    %f   %f   %f   %f   %f    \r\n',mean(mis),mean(el),mean(ec),mean(es),mean(tr),mean(dist));
fprintf(fid,'  dev.st.  %f    %f   %f   %f   %f   %f    \r\n',std(mis),std(el),std(ec),std(es),std(tr),std(dist));

fclose(fid)


% div_e_coin  vedi dividi e coincidi in sf_ps
%
% Consideriamo na pezzi ciascuno dei quali produce una Hough indipendente e
% ne facciamo le coincidenze. In ciascuna delle na ci va

A=6;
p=0.0001;%p=0
fap0=1.e-15;
pdfbin=binom_norm(1000,1/12.5,p,5); %figure,plot(pdfbin)
fap=y_gd(pdf2cdf(pdfbin,-1,1));%figure,plot(fap)
z=x_gd(pdfbin);
dd=dx_gd(pdfbin);
nx=length(z);
n=length(fap);

na=5;
roc=crea_mp(na);
dp=roc;
fa=dp;
dps=dp;

for i = 1:na
    a2=A/(sqrt(i));
    if i == 1
        fat=fap;
    else
        fat=fat.*fap;
    end
    nsh=round(a2/dd);
    fap1=fat(nsh+1:n);
    dp1=fat(1:n-nsh);
    roc.ch(i).x=fap1;
    roc.ch(i).y=dp1;
    dp.ch(i).x=z(nsh:n-1);
    dp.ch(i).y=dp1;
    fa.ch(i).x=z(1:n-nsh);
    fa.ch(i).y=dp1;
end

scr=sprintf('''ROC  A = %.1f''',A);
scr=['title(' scr '),xlabel(''False alarm probability''),ylabel(''Detection probability'')']
mp_plot(roc,2,'',scr);
% mp_plot(dp,3,'','title(''Detection probability''),xlabel(''z threshold'')');
% mp_plot(fa,3,'','title(''False alarm probability''),xlabel(''z threshold'')');

fap=pdf2cdf(pdfbin,-1,1);
signal=0:0.5:16;
for i = 1:na
    sig=signal/sqrt(i);
    if i == 1
        fat=fap;
    else
        fat=fat.*fap;
    end
    f=detect_prob(fat,fap0,sig);
    dps.ch(i).x=x_gd(f)*sqrt(i);
    dps.ch(i).y=y_gd(f);
end

scr=sprintf('''Detection probability  @ f.a.p. = %.2e''',fap0);
scr=['title(' scr '),xlabel(''Signal''),ylabel(''Detection probability'')'];
mp_plot(dps,3,'',scr);
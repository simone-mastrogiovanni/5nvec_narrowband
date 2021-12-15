% ROConLossFilt

% Fit

k4=4;

xloss0=out_ch{1}.xloss;
ploss0=out_ch{1}.ploss;

y1=2*xloss0.^2./(1+xloss0.^k4);

figure,loglog(xloss0,y1,'r.'),grid on
hold on,loglog(xloss0,ploss0)
title('ploss0 & fit')

figure,plot(xloss0,y1-ploss0),grid on,title('residuals')
figure,semilogx(xloss0,y1-ploss0),grid on,title('residuals')
figure,semilogx(xloss0,(y1-ploss0)./ploss0),grid on,title('relative residuals')

nn=length(out_ch);

% hloss

figure
leg=['{'];

for i = 1:nn
    xloss=out_ch{i}.xloss;
    hloss=out_ch{i}.hloss/((xloss(2)-xloss(1))*out_ch{i}.n);
    loglog(xloss,hloss),hold on
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('loss')
ylabel('hloss')
title('hloss')

% ploss

figure

for i = 1:nn
    xloss=out_ch{i}.xloss;
    ploss=out_ch{i}.ploss;
    loglog(xloss,ploss),hold on
end

grid on
eval(['legend(' leg ')'])
xlabel('loss')
ylabel('ploss')
title('ploss')

% ROC

figure
leg=['{'];

for i = 2:nn
    xloss=out_ch{i}.xloss;
    ploss=out_ch{i}.ploss;
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
    y0=2*xloss0.^2./(1+xloss0.^k4);
    loglog(y0,ploss),hold on
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('false alarm probability')
ylabel('detection probability')
title('ROC on loss parameter')

figure
for i = 2:nn
    xloss=out_ch{i}.xloss;
    ploss=out_ch{i}.ploss;
    snr=out_ch{i}.snr;
    y0=2*xloss0.^2./(1+xloss0.^k4);
    plot(y0,ploss),hold on
end

grid on
eval(['legend(' leg ')'])
xlabel('false alarm probability')
ylabel('detection probability')
title('ROC on loss parameter')

% DR Detection ratio

figure
leg=['{'];

for i = 2:nn
    xloss=out_ch{i}.xloss;
    ploss=out_ch{i}.ploss;
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
    y0=2*xloss0.^2./(1+xloss0.^k4);
    loglog(y0,ploss./y0),hold on
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('false alarm probability')
ylabel('detection ratio')
title('DR on loss parameter')


%-------------------------------------------
% filt detection

xa0=out_ch{1}.xha;
hha0=out_ch{1}.hha;
pha0=out_ch{1}.pha;

figure
[p,dx,n]=hist2prob(hha0,xa0,1,4);
figure
[fap,dx,n]=hist2prob(hha0,xa0,3,3);

left.llim=0.01;
left.par=1;
right.rlim=1;
right.par=-0.25;

% fapdf=hha0/(sum(hha0)*(xa0(2)-xa0(1)));
% Fap=cumsum(fapdf,'reverse')*(xa0(2)-xa0(1));
% 
% y2=xa0.^2./(2+xa0.^2);
% 
% figure,loglog(xa0,y2,'r.'),grid on
% hold on,loglog(xa0,pha0)
% title('pha0 & fit')

% ha

figure
leg=['{'];

for i = 1:nn
    xha=out_ch{i}.xha;
    hha=out_ch{i}.hha/((xha(2)-xha(1))*out_ch{i}.n);
    loglog(xha,hha),hold on
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('ha')
ylabel('hha')
title('hha')

% pha

figure

for i = 1:nn
    xha=out_ch{i}.xha;
    pha=out_ch{i}.pha;
    loglog(xha,pha),hold on
end

grid on
eval(['legend(' leg ')'])
xlabel('ha')
ylabel('pha')
title('pha')

% ROC

figure
leg=['{'];

for i = 2:nn
    xha=out_ch{i}.xha;
    hha=out_ch{i}.hha;
    pha=out_ch{i}.pha;
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
%     y0=xa0.^2./(2+xa0.^2);
    fap1=enl_hist2prob(hha0,xa0,xha,left,right,3,0);
    loglog(fap1,pha),hold on
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('false alarm probability')
ylabel('detection probability')
title('ROC on loss parameter')

figure
leg=['{'];
% nxa0=length(xa0);
% y1=y0(nxa0:-1:1);
for i = 2:nn
    xha=out_ch{i}.xha;
    hha=out_ch{i}.hha;
    pha=out_ch{i}.pha;
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
    fap1=enl_hist2prob(hha0,xa0,xha,left,right,3,0);
    plot(fap1,pha),hold on
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('false alarm probability')
ylabel('detection probability')
title('ROC on a parameter')

% Detection ratio

figure
leg=['{'];

for i = 2:nn
    xha=out_ch{i}.xha;
    hha=out_ch{i}.hha;
    pha=out_ch{i}.pha;
    snr=out_ch{i}.snr;
    leg=[leg '''snr=' num2str(snr),''','];
%     y0=xa0.^2./(2+xa0.^2);
    fap1=enl_hist2prob(hha0,xa0,xha,left,right,3,0);
    loglog(fap1,pha./fap1),hold on
end

grid on
leg=[leg '}'];
eval(['legend(' leg ')'])
xlabel('false alarm probability')
ylabel('detection probability')
title('detection on loss parameter')


% ROConLoss

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
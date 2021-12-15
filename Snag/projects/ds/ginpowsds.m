% ginpowsds   gui for pows_ds

sfr1=sprintf('%d',fr1);
sfr2=sprintf('%d',fr2);

answ=inputdlg({'type (0->single, 1->total, 2->ar, 3 last+ar',...
   'tau (only for autoregressive spectrum)',...
   'axes (0->linear, 1->log y, 2->log-log',...
   'output (0->power spectrum, 1->sqrt(p.s.*2)',...
   'window (0->no, 1->bartlett, 2->hanning, 3->flatcos)',...
   'min frequency','max frequency'},...
   'Power spectrum parameters',1,...
   {'1','6','1','1','3',sfr1,sfr2});

ichist=eval(answ{1});
tau=eval(answ{2});
iclog=eval(answ{3});
icsqrt=eval(answ{4});
icwind=eval(answ{5});
x1=eval(answ{6});
x2=eval(answ{7});
pause(2)
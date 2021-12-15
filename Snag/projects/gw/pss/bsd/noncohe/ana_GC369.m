% ana_GC369

% montare epochsO2

timerVal=tic
GC369

[addr,ant,runame,tim,targetL,SD]=bsd_funblock_0(0,'ligol',0,0,GC369L)
tics(1)=toc(timerVal)
[bsd_outL,BSD_tab_outL,stparL]=bsd_funblock_1(addr,ant,runame,tim,targetL)
tics(2)=toc(timerVal)
msgbox(sprintf('bsd_cohe : %s %s %s %f %s',addr,ant,runame,tim,targetL.name))
tics(3)=toc(timerVal)
pause(0.5)
coheL=bsd_cohe(bsd_outL,targetL)
tics(4)=toc(timerVal)
sL=bsd_pows(coheL.bsd_corr,2)
figure,semilogy(sL)
plot_lines(targetL.f0+(-2:2)/SD,sL)

[addr,ant,runame,tim,targetH,SD]=bsd_funblock_0(0,'ligoh',0,0,GC369H)
tics(5)=toc(timerVal)
[bsd_outH,BSD_tab_outH,stparH]=bsd_funblock_1(addr,ant,runame,tim,targetH)
tics(6)=toc(timerVal)
msgbox(sprintf('bsd_cohe : %s %s %s %f %s',addr,ant,runame,tim,targetH.name))
tics(7)=toc(timerVal)
pause(0.5)
coheH=bsd_cohe(bsd_outH,targetH)
tics(8)=toc(timerVal)
sH=bsd_pows(coheH.bsd_corr,2)
figure,semilogy(sH)
plot_lines(targetH.f0+(-2:2)/SD,sH)
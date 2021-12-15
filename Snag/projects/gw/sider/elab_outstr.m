function [fr sp ampsid phsid ampsol phsol lfsp percls percld percla perclw]=elab_outstr(outstr,capt,on)
% elab_outstr  using outstr array
%
%  outstr array produced by crea_outstr_VSR2_DF and similar
%  and retrieved by load outstr
%
%  on    selection on bands (0 or 1)
%
% %% Analysis for 500 Hz bands
% % VSR2 Dark Fringe data
% %%
% % crea_outstr_VSR2_DFl
% 
% load VSR2_SM
% maskcut=[0 60000];
% maskcut=[5.5116e+004 5.5128e+004];  % cut 12-Oct-2009 - 24-Oct-2009
% 
% for i = 1:20
%     %% New file
%     %  
%     strfil=sprintf('VSR2_aveDF_%02d',i);
%     fprintf('File %s band %d - %d Hz \n',strfil,(i-1)*500,i*500)
%     eval(['load ' strfil])
%     eval(['[g2out up low cut]=gd2_rough_clean(' strfil ',0.02,0.01,VSR2_SM,512/86400);'])
%     eval(['clear ' strfil])
%     g2out=mask_gd2(g2out,maskcut,[0 10000]);
%     outstr(i)=sid_band_analysis(g2out,0,virgo,'VSR2_DF',2);
% end
% 
% save('outstr','outstr')

if ~exist('capt','var')
    capt='';
end

capt=underscore_man(capt);

inifr=outstr.inifr

n=length(outstr);
[m1 m]=size(outstr(1).perpard);
dfr=outstr(1).perpard(1,2)-outstr(1).perpard(1,1);
ini=outstr(1).perpard(1,1);

if ~exist('on','var')
    on=ones(1,n);
end

stron=sprintf('%1d',on);

fr=[];
sp=[];  
ampsid=[]; 
phsid=[]; 
ampsol=[];
phsol=[];  
ampasid=[];
phasid=[];
ampw=[];
phw=[];
lfsp=0;
nlfsp=0;
lfspall=0;

for i = 1:n
    [m1 m]=size(outstr(i).perpard);
    fr=[fr outstr(i).perpard(1,1:m-1)];
    band=[round(outstr(i).perpard(1,1)+inifr) round(max(fr)+inifr)];
    sp=[sp outstr(i).perpard(2,1:m-1)];
    ampsid=[ampsid outstr(i).perpars(3,1:m-1)];
    phsid=[phsid outstr(i).perpars(4,1:m-1)];
    ampsol=[ampsol outstr(i).perpard(3,1:m-1)];
    phsol=[phsol outstr(i).perpard(4,1:m-1)];
    ampasid=[ampasid outstr(i).perpara(3,1:m-1)];
    phasid=[phasid outstr(i).perpara(4,1:m-1)];
    ampw=[ampw outstr(i).perparw(3,1:m-1)];
    phw=[phw outstr(i).perparw(4,1:m-1)];
    lfspall=lfspall+outstr(i).ps;
    if on(i) > 0
        lfsp=lfsp+outstr(i).ps;
        nlfsp=nlfsp+1;
        str=sprintf(' band %d-%d ',band);
        figure,plot(outstr(i).meanpers(1,:),outstr(i).meanpers(3,:)),hold on,grid on
        plot(outstr(i).meanperd(1,:),outstr(i).meanperd(3,:),'r')
        plot(outstr(i).meanpera(1,:),outstr(i).meanpera(3,:),'g')
        title([capt str ' - Sid (blue), Sol (red), Asid (green) epoch folding']),xlabel('hours')
    end
end

lfsp=lfsp/nlfsp;
lfspall=lfspall/n;
fr=fr+inifr;

figure,semilogy(fr,sp),xlabel('Hz'),title([capt ' - Spectral density']),grid on
xlim([min(fr) max(fr)])

figure,semilogy(fr,ampsid),hold on,plot(fr,ampsol,'r'),grid on
xlabel('Hz'),ylabel('fraction'),title([capt ' - Percentage amplitude (red solar, blue sidereal'])
xlim([min(fr) max(fr)])

figure,semilogy(fr,ampsid.*sp),hold on,plot(fr,ampsol.*sp,'r'),grid on
xlabel('Hz'),ylabel(' '),title([capt ' - Amplitude (red solar, blue sidereal'])
xlim([min(fr) max(fr)])

figure,plot(fr,phsid,'.'),hold on,plot(fr,phsol,'r.'),grid on
xlabel('Hz'),ylabel('hours');title([capt ' - Phase (red solar, blue sidereal'])
xlim([min(fr) max(fr)])

figure,semilogy(fr,ampsid.*sp),hold on,plot(fr,ampasid.*sp,'g'),grid on
xlabel('Hz'),ylabel(' '),title([capt ' - Amplitude (blue sidereal, green anti'])
xlim([min(fr) max(fr)])

figure,plot(fr,phsid,'.'),hold on,plot(fr,phasid,'g.'),grid on
xlabel('Hz'),ylabel('hours');title([capt ' - Phase (blue sidereal, green anti'])
xlim([min(fr) max(fr)])

if nlfsp < n
    show_spec_lines(lfsp,['Mean power spectrum on ' capt ' (sel ' stron ')'])
    show_spec_lines(lfspall,['Mean power spectrum on ' capt ' (all)'])
else
    show_spec_lines(lfspall,['Mean power spectrum on ' capt])
end

percls=outstr(1).percleans;
percld=outstr(1).percleand;
percla=outstr(1).percleana;
perclw=outstr(1).percleanw;

for i = 2:n
    percls=side_gd2(percls,outstr(i).percleans);
    percld=side_gd2(percld,outstr(i).percleand);
    percla=side_gd2(percla,outstr(i).percleana);
    perclw=side_gd2(perclw,outstr(i).percleanw);
end
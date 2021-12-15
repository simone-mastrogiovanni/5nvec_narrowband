% show_1Hz
%
% uses matlab files like 1Hz_raw_100903 in Raw_VSR2

fr=290;
typ=1           % 1 dai sunti   2 dai gd base
ant=ligoh;      % antenna
str='rawLH_';   % 'raw_' virgo, 'rawLH_' Hanford
SM=LH_S6_SM;    % VSR2_SM virgo, LH_S6_SM Hanford

thr=5;
band=[0.1 0.9;];

long=ant.long; 

if typ == 1
    str1=sprintf('%04d',fr);
    eval(['par=par' str1 ';']);
    eval(['tsid=tsid' str1 ';']);
    eval(['tsol=tsol' str1 ';']);
    eval(['sp1=sp1' str1 ';']);
else
    [tsol tsid sp1 par sp]=ana_1Hz(fr,str,thr,band,SM,long,1);
    
    sp=edit_gd(sp,'ini',fr)
    figure,plot(sp*1e-40),xlabel('Hz'),title('Power spectrum')
end

figure,show_phase_diagram(tsol.base,15),hold on,show_phase_diagram(tsol.fit,15,'r');title('Solar periodicity')
figure,show_phase_diagram(tsid.base,15);hold on,show_phase_diagram(tsid.fit,15,'r');title('Sidereal periodicity')
show_spec_lines(sp1),title('Low frequency pseudo-spectrum'),xlabel('days^{-1}')
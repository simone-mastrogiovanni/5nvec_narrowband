%% Analysis for 100 Hz bands - band 1900 - 2000 Hz
% Ligo Hanford data
%%
% pub_LH_S6_20_II

load LH_S6_SM

i=20
N=30;

strfil=sprintf('LH_S6_shsp_%02d',i);
fprintf('File %s band %d - %d Hz\n',strfil,(i-1)*100,i*100)
eval(['load ' strfil])
eval(['[g2out up low cut]=gd2_rough_clean(' strfil ',0.10,0.05,LH_S6_SM,512/86400);'])
g2out=cut_gd2(g2out,[30000 69215],[1 801]);
t=x_gd2(g2out);
t=t-v2mjd([2009 9 21 0 0 0]);
g2out=edit_gd2(g2out,'x',t);
pers=zeros(31,120);

dfr=(1.002737909350795-1)/5;
fr0=1-dfr*N;

for i = 1:2*N+1
    %% New file
    %
    
    fr=fr0+(i-1)*dfr;
    [periods percleans win perpar meanper]=gd2_period(g2out,fr,0);
%     show_gd2_per_par(perpar,meanper,sprintf('Frequency %d  %f Hz ',i,fr));
    pers(i,:)=meanper(3,:);
end

periodLHS6II=gd2(pers');
periodLHS6II=edit_gd2(periodLHS6II,'ini2',fr0,'dx2',dfr,'dx',0.2);
save('periodLHS6II','periodLHS6II')
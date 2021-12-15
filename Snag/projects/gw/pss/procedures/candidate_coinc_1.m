% candidate_coinc_1 single file candidate analysis

cand6=psc_type(1,150000,1,'pss_cand_c6_0456.cand');
cand7=psc_type(1,15000,1,'pss_cand_c7_0456.cand');

cand6=sortrows(cand6')';
cand7=sortrows(cand7')';

figure,plot(cand6(2,:),cand6(3,:),'b.'),grid on
figure,plot(cand7(2,:),cand7(3,:),'r.'),grid on

figure,plot(cand6(2,:),cand6(3,:),'bo'), hold on, grid on
plot(cand7(2,:),cand7(3,:),'rx')
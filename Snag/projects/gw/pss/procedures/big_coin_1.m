% big_coin

searstr.diffr=1;
searstr.diflam=1;
searstr.difbet=1;
searstr.difsd1=0.2;

[c_cand1A,c_cand2A]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[0 350],searstr);
save('C6C7coin_A','c_cand1A','c_cand2A');
clear

[c_cand1B,c_cand2B]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[350 550],searstr);
save('C6C7coin_B','c_cand1B','c_cand2B');
clear

[c_cand1C1,c_cand2C1]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[550 650],searstr);
save('C6C7coin_C1','c_cand1C1','c_cand2C1');
clear

[c_cand1C2,c_cand2C2]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[650 750],searstr);
save('C6C7coin_C2','c_cand1C2','c_cand2C2');
clear

[c_cand1C3,c_cand2C3]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[750 850],searstr);
save('C6C7coin_C3','c_cand1C3','c_cand2C3');
clear

[c_cand1C4,c_cand2C4]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[850 950],searstr);
save('C6C7coin_C4','c_cand1C4','c_cand2C4');
clear

[c_cand1C5,c_cand2C5]=psc_coin('K:\pss\virgo\cand\PSC_DB-c7_1000\','K:\pss\virgo\cand\PSC_DB-c6_1000\',[950 1050],searstr);
save('C6C7coin_C5','c_cand1C5','c_cand2C5');
clear

% psc_reshape_db2(1,'K:\pss\virgo\cand\PSC_DB_c6-c7_part1\','K:\pss\virgo\cand\PSC_DB_c6-c7_part1\')
% psc_reshape_db2(1,'K:\pss\virgo\cand\PSC_DB_c6-c7_part2\','K:\pss\virgo\cand\PSC_DB_c6-c7_part2\')
% 
% [c_cand1EQ,c_cand2EQ]=psc_coin('K:\pss\virgo\cand\PSC_DB_c6-c7_part1\','K:\pss\virgo\cand\PSC_DB_c6-c7_part2\');
% save('C6C7coin_EQ','c_cand1EQ','c_cand2EQ');
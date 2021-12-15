% check_fake_source_old

fake_source_file='K:\pss\virgo\pm\sim7\fake100signals_corr.dat';

fake_source=read_piasourcefile(fake_source_file);

% cand=psc_type(1,3000000,1,'K:\pss\virgo\cand\PSC_DB-c7_sim_clean\1000\40\pss_cand_1040.cand');

[c_cand1,c_cand2]=psc_coin_list('K:\pss\virgo\cand\PSC-DB_c7_sim\',fake_source,0);

resfile='fcand';
resfile=[resfile '_' datestr(now,30)];
eval(['save ' resfile ' c_cand1 c_cand2'])
% check_fake_source NO FAKE FACTOR !

fake_source_file='I:\pss\metadata\FakeSources\sourcefile1.dat';

[fcand sour]=pss_readsourcefile(fake_source_file);

% cand=psc_type(1,3000000,1,'K:\pss\virgo\cand\PSC_DB-c7_sim_clean\1000\40\pss_cand_1040.cand');

searstr.diffr=1;
searstr.diflam=1000;
searstr.difbet=1000;
searstr.difsd1=1;

[c_cand1,c_cand2]=psc_coin_list('I:\pss\virgo\cand\PSC-DB_c7_sim_s1\',fcand,0,searstr);

resfile='fcand';
resfile=[resfile '_' datestr(now,30)];
eval(['save ' resfile ' c_cand1 c_cand2'])
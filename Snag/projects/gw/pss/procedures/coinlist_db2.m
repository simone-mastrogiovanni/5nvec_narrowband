% coinlist_db2

[fcand sour]=pss_readsourcefile('I:\pss\metadata\FakeSources\sourcefile1.dat',0,80);

[c_cand1,c_cand2]=psc_coin_list_db2('I:\pss\virgo\cand\PSC-DB_c7_sim_clean_t80\db2\',fcand,0);

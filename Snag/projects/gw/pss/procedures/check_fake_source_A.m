% check_fake_source_A

fake_source_file='o:\pss\metadata\FakeSources\sourcefile1.dat';

[fcand sour]=pss_readsourcefile(fake_source_file,0,80);

fcand.cand(2,:)=mod(fcand.cand(2,:)+180,360);  % CORREZ antipodi
fcand.cand(3,:)=-fcand.cand(3,:);              % CORREZ antipodi

searstr.diffr=1;
searstr.diflam=10;
searstr.difbet=10;
searstr.difsd1=1;

[c_cand1,c_cand2]=psc_coin_list('o:\pss\virgo\cand\PSC-DB_c7_sim_clean_t80\',fcand,[40 550],searstr);

resfile='fcand';
resfile=[resfile '_' datestr(now,30)];
eval(['save ' resfile ' c_cand1 c_cand2'])
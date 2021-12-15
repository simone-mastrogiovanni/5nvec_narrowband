% reshape_db2  pss candidate post-processing

% PSC_RESHAPE_DB2  type 2 pss candidate files post-processing
%                  High speed
%
%       psc_reshape_db2(op,dirin,dirout,infr1,infr2)
%
%  op           operation:
%                 0 -> sort input files
%                 1 -> to 242 files (first coincidence group) (contains sort)
%                 2 -> to 242 files (second coincidence group) (contains sort)
%
%  dirin         input directory (root)
%  dirout        output directory (root)
%  infr1,infr2   min,max value of frequency groups (def 1 - 200)

psc_reshape_db2(1,'I:\pss\virgo\cand\PSC-DB_c7_clean\','I:\pss\virgo\cand\PSC-DB_c7_clean\db2\');

psc_reshape_db2(1,'I:\pss\virgo\cand\PSC-DB_c7_sim_s1\','I:\pss\virgo\cand\PSC-DB_c7_sim_s1\db2\');

psc_reshape_db2(1,'I:\pss\virgo\cand\PSC-DB_c7_sim_clean_t80\','I:\pss\virgo\cand\PSC-DB_c7_sim_clean_t80\db2\');


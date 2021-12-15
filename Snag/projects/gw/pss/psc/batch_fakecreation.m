% batch_fakecreation : template of batch creation of fake candidates
%
% the folder structure should exist (see pss/metadata/templates/pss_cand/)

NN=1.e8;

disp(['start 1 at ' datestr(now)])
crea_pssfakecand('./y1/',NN);

disp(['start 2 at ' datestr(now)])
crea_pssfakecand('./y2/',NN);
disp(['end at ' datestr(now)])
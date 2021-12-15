% resam_reshap_hp

dirin='k:\pss\ligo_h\sd\sds\sds_H-H1_RDS_C02_LX-8575\';
% dirin='K:\pss\ligo_h\sd\sds\sds_resampling_H-H1_RDS_C02_LX-8575\';
dirout='k:\pss\ligo_h\sd\sds\sds_H-H1_RDS_C02_LX-8575-4kHz_hpB\';
sds_reshp_reshape([dirin 'lista8575.txt'],80000000,4000,22,8,dirin,dirout);
% sds_reshp_reshape([dirin 'list8575resh.txt'],80000000,4000,22,8,dirin,dirout);
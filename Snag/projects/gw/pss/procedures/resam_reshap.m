% resam_reshap

dirin='k:\pss\ligo_h\sd\sds\sds_H-H1_RDS_C02_LX-8575\';
dirout='k:\pss\ligo_h\sd\sds\sds_H-H1_RDS_C02_LX-8575-4kHz\';
sds_resam_reshape([dirin 'lista8575.txt'],81920000,4000,8,dirin,dirout);

% addobba_notch
 
anabasic.tfh_thr=95;
anabasic.noplot=1;

lines=ligo_readlines('O2L1lines.csv');
parnotch.linel=lines;
parnotch.thr=0.25;
parnotch.win=1;
 
% list='list_O1_L_raw.txt';
% 
% outL=bsd_tfstr_add(list,anabasic)
 
list='list_O2_L_sccl.txt';
 
outH=bsd_tfstr_addwithnotch(list,parnotch,anabasic)

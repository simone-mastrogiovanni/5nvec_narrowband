% check_5vec_prob_filt

savefil='base_prob_v5filt';
target=pulsar_3;
ant=ligol
n=1000000;

snrs=[0,0.1,0.2,0.5,1,2,5,10,20,50,100];
nn=length(snrs);
out_ch=cell(nn,1);

for i = 1:nn
    snr=snrs(i);
    out_pr=prob_5vec_filt(ant,target,snr,n);
    out_ch{i}=out_pr;
    pause(1)
end

eval(['save(''' savefil ''',''out_ch'');'])
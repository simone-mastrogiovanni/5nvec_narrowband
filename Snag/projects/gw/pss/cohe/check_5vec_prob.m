% check_5vec_prob

savefil='base_prob_v5';
target=pulsar_3;
ant=ligol;
v.ant=ant;
v.sour=target;
n=1000000;

snrs=[0,0.1,0.2,0.5,1,2,5,10,20,50,100];
nn=length(snrs);
out_ch=cell(nn,1);

for i = 1:nn
    snr=snrs(i);
    out_pr=prob_5vec(v,snr,n);
    out_ch{i}=out_pr;
    pause(1)
end

eval(['save(''' savefil ''',''out_ch'');'])
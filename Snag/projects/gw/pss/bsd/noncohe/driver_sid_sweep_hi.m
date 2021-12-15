% driver_sid_sweep_hi

kpuls=[0 1 2 3 5 6 8 9 10 11];
epochO2=57870; 
 
bw=10; %   bw      narrow bandwidth in units of 1/SD (typically 10)

for ipul = kpuls
    puls=['pulsar_' num2str(ipul)];
    sidsL=['sids2_p' num2str(ipul) '_' num2str(bw) '_L'];
    sidsH=['sids2_p' num2str(ipul) '_' num2str(bw) '_H'];
    
    eval([puls '=new_posfr(' puls ',epochO2);']);
    eval(['pfr0=' puls '.f0;'])
    
    eval([sidsL '=sid_sweep(''I:'',''ligol'',''O2'',' num2str(pfr0) ',' puls ',1,10)'])
    eval(['save(''' sidsL ''',''' sidsL ''');'])
    
    eval([sidsH '=sid_sweep(''I:'',''ligoh'',''O2'',' num2str(pfr0) ',' puls ',1,10)'])
    eval(['save(''' sidsH ''',''' sidsH ''');'])
end
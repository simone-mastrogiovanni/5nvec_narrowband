% follow_hinj_1

ant='ligol';
ant1='L_';

epoch=v2mjd([2017 1 1]);

for i = 13:14
    puls=['pulsar_' num2str(i)];
    eval([puls 'A=new_posfr(' puls ',epoch);'])
    eval([ant1 puls '=sid_sweep_tf(''J:'',''' ant ''',''O2'',' puls 'A.f0,' puls ',[10,5],7);'])
    eval(['save(''' ant1 puls ''',''' ant1 puls ''')'])
end

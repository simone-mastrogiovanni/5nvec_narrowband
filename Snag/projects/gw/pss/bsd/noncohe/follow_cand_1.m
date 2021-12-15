% follow_cand_1

ant='ligol';
ant1='L';
pos='_GC_';

frcand=[80.03144716
200.2392189
203.9742236
227.7629126
488.3348368
524.3393044
531.1259047
716.0532049
930.3960485
1184.548527
1404.366458
1463.462946
1581.119174
1663.149171
1973.277106
2017.351895
]

frcand(1)=frcand(1)+0.47;
frcand(2)=frcand(2)+0.27;
frcand(9)=frcand(9)+0.17;
ncand=length(frcand);

for i = 13:ncand
    candout=[ant1 pos num2str(frcand(i))];
    ii=strfind(candout,'.')
    candout(ii)='_';
    eval([candout '=sid_sweep_tf(''J:'',''' ant ''',''O2'',frcand(i),GC,[10,5],7);'])
    eval(['save(''' candout ''',''' candout ''')'])
end

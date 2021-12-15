% crea_mat10Hz

head='VSR4_1';
list='I:\pss\virgo\hfdf\VSR4\v0\256Hz-hp20\output\ana1\list.txt';

% head='VSR2_1';
% list='I:\pss\virgo\hfdf\VSR2\v3\256Hz-hp20\output\ana1\list.txt';

ini=10;
fin=30;
step=10;

while fin <= 139
    name=sprintf('%s_%03d%03d',head,ini,fin)
    range=sprintf('%3d %3d',ini,fin);
    ini=fin;
    fin=fin+step;
    
    eval([name '=read_cand_2013(''' list ''',['  range ']);']);
    eval(['save(''' name ''',''' name ''',''-v7.3'')'])
    eval(['clear ' name]); 
end


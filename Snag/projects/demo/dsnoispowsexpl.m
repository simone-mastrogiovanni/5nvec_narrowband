%dsnoispowsexpl   explorer noise continuous monitoring 

l=32768;
buff=zeros(1,3*(l/2));
powsout=zeros(1,l);
d=ds(l);
dt=1/55.01;
d=edit_ds(d,'dt',dt,'type',1);

setsnag
load data\spexplorer.mat;
sp=y_gd(spexplorer);

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   powsout=pows_ds(d,powsout,'total','limit',0,55.01/2,'logy','sqrt','hwindow');
   pause(2);
end

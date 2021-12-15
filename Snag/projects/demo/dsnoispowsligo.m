%dsnoispowsligo   ligo 40m noise continuous monitoring 

l=16384/2;
buff=zeros(1,3*(l/2));
powsout=zeros(1,l);
d=ds(l);
dt=0.0001;
d=edit_ds(d,'dt',dt,'type',1);

% setsnag
eval(['load ' snagdir 'data\spectra\ligospec.mat']);
sp=y_gd(gdspligo);

for i =1:20
   [d,buff]=noise_ds(d,buff,'spect',sp);
   powsout=pows_ds(d,powsout,'total','limit',0,5000,'logy','sqrt','hwindow');
   pause(2);
end

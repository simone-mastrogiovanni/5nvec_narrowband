%ligodata2   ligo data

g=gd(IFO_DMRO);
g=edit_gd(g,'dx',1/rate_IFO_DMRO,'capt','IFO_DMRO')
l=8192;
buff=zeros(1,3*(l/2));
powsout=zeros(1,l);
d=ds(l);
d=edit_ds(d,'type',1);
n20=floor(n_gd(g)/l)

for i =1:n20
   d=gd2ds(d,g);
   [powsout,answ]=ipows_ds(d,powsout,answ,'interact','dar',6,'limit',0,5000,'loglog','sqrt','hwindow');
   pause(2);
end

%ligodata1   ligo data

g=gd(IFO_DMRO);
g=edit_gd(g,'dx',1/rate_IFO_DMRO,'capt','IFO_DMRO')
l=4096;
buff=zeros(1,3*(l/2));
powsout=zeros(1,l);
d=ds(l);
d=edit_ds(d,'type',1);

for i =1:20
   d=gd2ds(d,g);
   powsout=pows_ds(d,powsout,'total','limit',0,5000,'loglog','sqrt','hwindow');
   pause(2);
end

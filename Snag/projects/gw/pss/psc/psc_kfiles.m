function k=psc_kfiles(lam,bet)
%PSC_KFILES  which of the 242 file to take
%            (vector version)
%
%  lam,bet   ecliptic coordinates (degrees)

if min(lam) < 0
    a=find(lam<0);
    disp(sprintf(' *** min lambda %f - %d values out',min(lam),length(a)))
end
if max(lam) > 360
    a=find(lam>360);
    disp(sprintf(' *** max lambda %f - %d values out',max(lam),length(a)))
end
if min(bet) < -90
    a=find(bet<-90);
    disp(sprintf(' *** min beta %f - %d values out',min(bet),length(a)))
end
if max(bet) > 90
    a=find(bet>90);
    disp(sprintf(' *** max beta %f - %d values out',max(bet),length(a)))
end

ilam=floor(lam/15)+1;
i=find(ilam>24);
ilam(i)=24;

ibet=floor((bet+75)/15);

k=ilam+ibet*24;

i=find(ibet<0); 
k(i)=241;

i=find(ibet>9); 
k(i)=242;

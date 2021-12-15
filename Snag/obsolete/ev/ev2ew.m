function ew=ev2ew(ev)
%EV2EW   from array of structure to structure of arrays

n=length(ev);

t(1:n)=0;
tm=t;
ch=t;
a=t;
cr=t;
a2=t;
l=t;
fl=t;
ci=t;

for i = 1:n
    t(i)=ev(i).t;
    tm(i)=ev(i).tm;
    ch(i)=ev(i).ch;
    a(i)=ev(i).a;
    cr(i)=ev(i).cr;
    a2(i)=ev(i).a2;
    l(i)=ev(i).l;
    fl(i)=ev(i).fl;
    ci(i)=ev(i).ci;
end

ew.t=t;
ew.tm=tm;
ew.ch=ch;
ew.a=a;
ew.cr=cr;
ew.a2=a2;
ew.l=l;
ew.fl=fl;
ew.ci=ci;
ew.nev=n;
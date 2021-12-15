function evcho=cl_search(evchi,dt)
%CL_SEARCH  event cluster search
%
%    evchi   event-channel input structure
%     dt     dead-time (s)
%
%    evcho   event-channel ouput structure

evcho=evchi;
nchtot=length(evchi.ch.an);
ncl=1;
clon=0;
t=zeros(1,floor(evchi.n/2));
a=t;
l=t;
ddt=dt/86400;

t1=evchi.ev(1).t+evchi.ev(1).l/86400;

for i = 2:evchi.n
    t2=evchi.ev(i).t;
    if t2-t1 <= ddt
        if clon == 0
            clon=1;
            aa=1;
            mine=t1;
            maxe=t1+evchi.ev(i).l/86400;
            t(ncl)=t1;
        end
        aa=aa+1;
        evcho.ev(i-1).ci=ncl;
        maxe=max(maxe,t2+evchi.ev(i).l/86400);
    else
        if clon == 1
            evcho.ev(i-1).ci=ncl;
            a(ncl)=aa;
            l(ncl)=maxe-mine;
            clon=0;
            ncl=ncl+1;
        end
    end
    t1=max(t1,t2+evchi.ev(i).l/86400);
end

ncl=ncl-1
n=evchi.n;

for i = 1:ncl
    k=n+ncl+1-i;
    evcho.ev(k).t=t(i);
    evcho.ev(k).tm=t(i);
    evcho.ev(k).a=a(i);
    evcho.ev(k).cr=a(i);
    evcho.ev(k).l=l(i)*86400;
    evcho.ev(k).ch=nchtot+1;
    evcho.ev(k).ci=i;
end

evcho.ch.na=evcho.ch.na+1;
evcho.ch.nch(evcho.ch.na)=1;
evcho.ch.an(nchtot+1)=evcho.ch.na;
evcho.ch.ty(nchtot+1)={'coin'};
evcho.ch.cf(nchtot+1)=0;
evcho.ch.bw(nchtot+1)=0;
evcho.n=evchi.n+ncl;

evcho.ev=sort_ev(evcho.ev);
    
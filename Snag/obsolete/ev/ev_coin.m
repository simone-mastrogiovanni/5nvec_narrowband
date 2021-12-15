function dcp=ev_coin(evch,selch,dt,n)
%EV_COIN   event coincidence by delay coincidence plot
%
%   evch    event-channel structure
%   selch   selection array for the channels (0 exclude, 1 first group, 2 second group)
%   dt      time resolution (s)
%   n       number of delays per side
%
%   dcp     output delay coincidence plot

nchtot=length(evch.ch.an);
i1=0;i2=0;
t1(1:evch.n)=0;
l1=t1;
t2=t1;
l2=t1;

for i = 1:evch.n
    for j = find(selch==1)
        if j == evch.ev(i).ch
            i1=i1+1;
            t1(i1)=evch.ev(i).t;
            l1(i1)=evch.ev(i).l;
        end
    end
    for j = find(selch==2)
        if j == evch.ev(i).ch
            i2=i2+1;
            t2(i2)=evch.ev(i).t;
            l2(i2)=evch.ev(i).l;
        end
    end
end
i1,i2
t1=t1(1:i1);
l1=l1(1:i1);
t2=t2(1:i2);
l2=l2(1:i2);

dcp=vec_coin(t1,l1,t2,l2,dt,n);

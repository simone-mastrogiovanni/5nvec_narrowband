function [dcp,in3,len3]=vec_coin(in1,len1,in2,len2,dt,n)
%VEC_COIN  produces a delay coincidence plot from 2 event sets
%
%    in1,len1   starting time and length of the first set of events (days,s)
%    in2,len2   starting time and length of the second set of events (days,s)
%    dt         delay interval (s)
%    n          number of intervals for each side
%
%    dcp        delay coincidence plot
%    in3        coincidence starting time
%    len3       coincidence length

%!! DA FARE LE LUNGHEZZE !!!

m1=length(in1);
m2=length(in2);
dcp=zeros(1,2*n+1);
in3=zeros(1,min(m1,m2));
len3=in3;

ddt=dt/86400;
t0=n*ddt;

k2=1;

for i = 1:m1
    t=in1(i);
    for j = k2:m2
        tt=t-in2(j);
        if tt > t0
            k2=j;
            continue;
        end
        if tt < -t0+ddt
            break
        end
        ktt=round(tt/ddt)+n;
        dcp(ktt)=dcp(ktt)+1;
    end
end

figure
stairs((-n:n)*dt+dt/2,dcp);zoom on, grid on


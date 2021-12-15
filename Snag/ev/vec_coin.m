function [dcp,in3,len3]=vec_coin(in1,len1,in2,len2,dt,n,coinfun,a1,a2)
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

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

cf=0;

if exist('coinfun')
    if isa(coinfun,'function_handle')
        cf=1;
    else
        disp(' *** NOT A FUNCTION HANDLE !!!')
    end
end

m1=length(in1);
m2=length(in2);
m3=0;
len1=len1/86400;
len2=len2/86400;
dcp=zeros(1,2*n+1);
in3=zeros(1,min(m1,m2));
len3=in3;

ddt=dt/86400;
t0=n*ddt;

k2=1;

for i = 1:m1
    t=in1(i);
    for j = k2:m2
        tt1=t-in2(j)-len2(j);
        tt2=t+len1(i)-in2(j);
        
        if tt2 > t0
            k2=j;
            continue;
        end
        if tt1 < -t0+ddt
            break
        end
        
        if cf == 1
            if feval(coinfun,len1(i),len2(j),a1(i),a2(j)) <= 0
                continue
            end
        end
        
        ktt1=round(tt1/ddt)+n+1;
        ktt2=round(tt2/ddt)+n+1;
        dcp(ktt1:ktt2)=dcp(ktt1:ktt2)+1;
        
        if (ktt1 <= n+1) &  (ktt2 >= n+1)
            m3=m3+1;
            in3(m3)=in1(i);
            len3(m3)=(ktt2-ktt1+1)*ddt*86400;
        end
    end
end

if m3 > 0
    in3=in3(1:m3);
    len3=len3(1:m3);
else
    in3 = 0;
end

figure
stairs((-n:n)*dt-dt/2,dcp);zoom on, grid on


function [dcp,t3,dens]=vec_coin_nolen(t1,t2,dt,n,mode,coinfun,a1,a2)
%VEC_COIN_NOLEN  produces a delay coincidence plot from 2 event sets, not considering the length
%
%    t1         time of the first set of events (days)
%    t2         time of the second set of events (days)
%    dt         delay interval (s)
%    n          number of intervals for each side
%    mode       mode(1) operative mode : 1 normal, 2 density 
%               mode(2) density time scale (s)
%    coinfun    if exist, function handle or 0
%    a1,a2      amplitudes
%
%    dcp        delay coincidence plot
%    t3         time of coincident events

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

cf=0;
dens=1;

if exist('coinfun')
    if isa(coinfun,'function_handle')
        cf=1;
    else
        if coinfun ~= 0
            disp(' *** NOT A FUNCTION HANDLE !!!')
        end
    end
end

hi=0;

if ~exist('mode')
    mode=0;
end

if mode(1) == 2
    if length(mode) < 2
        mode(2)=3600;
    end
end

m1=length(t1);
m2=length(t2);
dcp=zeros(1,2*n+1);
m3=0;

if mode(1) == 2
    tini=min([min(t1) min(t2)]);
    tfin=max([max(t1) max(t2)]);
    nd=ceil((tfin-tini)*86400/mode(2))+1;
    if floor(nd/2)*2 ~= nd
        nd=nd+1;
    end
    
    x=(0:nd-1)*(tfin-tini)/nd+tini;
    hi1=hist(t1,x);
    hi2=hist(t2,x);
    hi1(1)=hi1(1)*2;
    hi2(1)=hi2(1)*2;
    hi1(nd)=hi1(nd)*2;
    hi2(nd)=hi2(nd)*2;
    shi1=sum(hi1);
    shi2=sum(hi2);
    nf2=nd/2-1;
    bart=(1:nf2)/(nf2+1);
    
    fhi1=fft(hi1);
    fhi1(2:nf2+1)=fhi1(2:nf2+1).*bart(nf2:-1:1);
    fhi1(nd-nf2+1:nd)=fhi1(nd-nf2+1:nd).*bart;
    fhi1(nf2+2)=0;
    hi1=real(ifft(fhi1));
    hi1=hi1*shi1/sum(hi1);
    
    fhi2=fft(hi2);
    fhi2(2:nf2+1)=fhi2(2:nf2+1).*bart(nf2:-1:1);
    fhi2(nd-nf2+1:nd)=fhi2(nd-nf2+1:nd).*bart;
    fhi2(nf2+2)=0;
    hi2=real(ifft(fhi2));
    hi2=hi2*shi2/sum(hi2);figure,plot(hi1),hold on,plot(hi2,'r')
    
    mh1=mean(find(hi1>0));
    mh2=mean(find(hi2>0));
    hi=hi1*0+1;
    dens=hi1.*hi2+mh1*mh2/2;  % CONTROLLARE
    hi=1./dens;
end

ddt=dt/86400;
t0=n*ddt;

k2=1;
evamp=1;

for i = 1:m1
    t=t1(i);
    for j = k2:m2
        tt=t-t2(j);
        if tt > t0
            k2=j;
            continue;
        end
        if tt < -t0+ddt
            break
        end
        
        if cf == 1
            if feval(coinfun,1,1,a1(i),a2(j)) <= 0
                continue
            end
        end
        
        if mode(1) == 2
            t12=(t1(i)+t2(j))/2;
            evamp=interp1(x,hi,t12);
        end
        
        ktt=round(tt/ddt)+n+1;
        dcp(ktt)=dcp(ktt)+evamp;
        if ktt == n+1
            m3=m3+1;
            t3(m3)=(t1(i)+t2(j))/2;
        end
    end
end

if m3 > 0
    t3=t3(1:m3);
else
    t3 = 0;
end

figure
stairs((-n:n)*dt-dt/2,dcp);zoom on, grid on


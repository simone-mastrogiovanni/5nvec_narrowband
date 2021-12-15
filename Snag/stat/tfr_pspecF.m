function [sp,AU]=tfr_pspecF(tt,T,res,dt)
% Time-frequency pulse power spectrum - Fast version by autocorrelation
%
%    sp=tfr_pspecF(tt,T,res,dt)
%
%   tt    events time (in days or seconds if negative)
%   T     time window (in days); if 2 numbers, [T_data T_max_autcor]
%   res   spectral resolution (>=1)
%   dt    autocorrelation resolution

% Version 2.0 - December 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

minnumev=4;
if res < 1
    res=1;
end

if tt(1) > 0
    tt=tt*86400;
else
    tt=-tt;
end
tt=sort(tt);
T0=tt(length(tt))-tt(1);
T=T*86400;
ntt=length(tt);
T2=T/2;
Nt=ceil(T0/T2);

it=floor((tt-tt(1))/T2)+1;
fin=ones(Nt,1);

for i = 1:Nt
    fin1=max(find(it == i));
    if ~isempty(fin1)
        fin(i)=fin1;
    end
end

tau=0:dt:T2;
ntau=length(tau);
Ntau=round(ntau*res);
sp=zeros(Ntau,Nt);
AU=zeros(ntau,Nt);
i1=1;

fprintf('%d events, Nt = %d, ntau = %d, Ntau = %d \n',ntt,Nt,ntau,Ntau);

for i = 1:Nt
    ttt=tt(i1:fin(i));
    nttt=length(ttt);
    if i > 1
        i1=fin(i-1)+1;
    end
    if nttt >= minnumev
        fprintf('%d period: %d events \n',i,nttt);
        au=tau*0;
        
        for j = 1:nttt-1
            k=ceil((tt(i+1:nttt)-tt(i))/dt+0.5);
            ii=find(k<=ntau);
            k=k(ii);
            au(k)=au(k)+1;
        end
        au(1)=au(1)*2+nttt;
        
        
%         for j = 1:nttt
%             dttt=ttt(j)-ttt;
%             h=hist(dttt,tau);
%             au=au+h;
%         end
%         au(ntau)=0;
        au=au/nttt^2;
        AU(:,i)=au;
        au(Ntau*2:-1:Ntau*2-ntau+2)=au(2:ntau);
        sp1=abs(fft(au));
        sp(:,i)=sp1(1:Ntau);
    end
end

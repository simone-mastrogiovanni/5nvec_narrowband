function aaout=anana_sid_sweep(pref,ants,thr,range)
% analysis after ana_sid_sweep
%
%   pref    prefix (ex.: sids_GC_O2_)
%   ants    cell array with at least two of 'L' 'H' 'V'
%   thr     threshold (def 1.e7)
%   range   def 10:10:1000

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('thr','var')
    thr=1e7;
end
if ~exist('range','var')
    range=10:10:1000;
end

nant=length(ants);

exclband=0.001;

Nrange=length(range);
aaout.cands=[];
aaout.candr=[];
aaout.candn=[];
aaout.hPsigtot=zeros(1,100);
aaout.hPrattot=zeros(1,100);
aaout.hPnoistot=zeros(1,100);
for k = 1:nant+1
    Amean{k}=[];
    Amed{k}=[];
    Astd{k}=[];
end

dx=0.1;
hx=(dx:dx:10)-dx/2;
aaout.hx=hx;
icprimo=1;

for i = 1:Nrange
    fr1=range(i);
    iant=1;
    Psig=1;
    Prat=1;
    Pnois=1;
    sigprod=1;
    noisprod=1;
    icsig=0;
    for k = 1:nant
        fil{k}=sprintf('%s%04d_%04d_%s',pref,fr1,fr1+10,ants{k});
    
        try
            eval(['load(''' fil{k} ''');'])
        catch
            sprintf(' *** %s is not present',fil{k})
            sidstr{k}=[];
            iant=0;
            continue
        end
        if icprimo
            N=sids.N;
            Nmax=floor(N*(10-exclband)/10);%Nmax=N
            aaout.N=N;
            aaout.Nmax=Nmax;
            icprimo=0;
        end
        sidstr{k}=sids;
        fr{k}=sidstr{k}.fr;
        sidsig{k}=sidstr{k}.sidsig;
        sidnois{k}=sidstr{k}.sidnois;
        sidrat{k}=sidsig{k}./sidnois{k};
        sigprod=sigprod.*sidsig{k};
        noisprod=noisprod.*sidnois{k};
        sidsig1=sidsig{k};
        sidsig1(Nmax+1:N)=min(sidsig1).*rand(1,N-Nmax);
        psig{k}=sort_p_rank(sidsig1);
        sidrat1=sidrat{k};
        sidrat1(Nmax+1:N)=min(sidrat1).*rand(1,N-Nmax);
        prat{k}=sort_p_rank(sidrat1);
        sidnois1=sidnois{k};
        sidnois1(Nmax+1:N)=min(sidnois1).*rand(1,N-Nmax);
        pnois{k}=sort_p_rank(sidnois1);
        Psig=Psig./psig{k};
        Prat=Prat./prat{k};
        Pnois=Pnois./pnois{k};
        measig=zeros(1,1000);
        medsig=measig;
        stdsig=measig;
        meanois=measig;
        mednois=measig;
        stdnois=measig;
        j1=1;
        for j = 1:1000
            j2=floor(j*N/1000)-1;
            measig(j)=mean(sidsig{k}(j1:j2));
            medsig(j)=median(sidsig{k}(j1:j2));
            stdsig(j)=std(sidsig{k}(j1:j2));
            meanois(j)=mean(sidnois{k}(j1:j2));
            mednois(j)=median(sidnois{k}(j1:j2));
            stdnois(j)=std(sidnois{k}(j1:j2));
            j1=j2+1;
        end
        Measig{k}((i-1)*1000+1:i*1000)=measig;
        Medsig{k}((i-1)*1000+1:i*1000)=medsig;
        Stdsig{k}((i-1)*1000+1:i*1000)=stdsig;
        Meanois{k}((i-1)*1000+1:i*1000)=meanois;
        Mednois{k}((i-1)*1000+1:i*1000)=mednois;
        Stdnois{k}((i-1)*1000+1:i*1000)=stdnois;
    end
    
    for j = 1:1000
        j2=floor(j*N/1000)-1;
        measigprod(j)=mean(sigprod(j1:j2));
        medsigprod(j)=median(sigprod(j1:j2));
        stdsigprod(j)=std(sigprod(j1:j2));
        meanoisprod(j)=mean(noisprod(j1:j2));
        mednoisprod(j)=median(noisprod(j1:j2));
        stdnoisprod(j)=std(noisprod(j1:j2));
        j1=j2+1;
    end
    Measig{nant+1}((i-1)*1000+1:i*1000)=measigprod;
    Medsig{nant+1}((i-1)*1000+1:i*1000)=medsigprod;
    Stdsig{nant+1}((i-1)*1000+1:i*1000)=stdsigprod;
    Meanois{nant+1}((i-1)*1000+1:i*1000)=meanoisprod;
    Mednois{nant+1}((i-1)*1000+1:i*1000)=mednoisprod;
    Stdnois{nant+1}((i-1)*1000+1:i*1000)=stdnoisprod;
        
    fr0=fr{1};
%     Psig(Nmax:N)=1;
%     Prat(Nmax:N)=1;
    
    if iant == 1
        ii=find(Prat >= thr);
        if length(ii) > 0
            for j = 1:length(ii)
                frr=fr{1}(ii(j));
                amp=Prat(ii(j));
                aaout.candr=[aaout.candr [frr;amp]];
            end
            icsig=1;
        end
        ii=find(Psig >= thr);
        if length(ii) > 0
            for j = 1:length(ii)
                frr=fr{1}(ii(j));
                amp=Psig(ii(j));
                aaout.cands=[aaout.cands [frr;amp]];
            end
            icsig=1;
        end
        hh=hist(log10(Psig),hx);
        aaout.hPsigtot=aaout.hPsigtot+hh;
        aaout.hPsig{i}=hh;
        hh=hist(log10(Prat),hx);
        aaout.hPrattot=aaout.hPrattot+hh;
        aaout.hPrat{i}=hh;
        ii=find(Pnois >= thr);
        if length(ii) > 0
            for j = 1:length(ii)
                frr=fr{1}(ii(j));
                amp=Pnois(ii(j));
                aaout.candn=[aaout.candn [frr;amp]];
            end
            icsig=1;
        end
    end
    if icsig
        figure,semilogy(fr0,Psig,'.'),hold on,semilogy(fr0,Prat,'r.'),grid on
    end
end

aaout.Measig=Measig;
aaout.Medsig=Medsig;
aaout.Stdsig=Stdsig;
aaout.Meanois=Meanois;
aaout.Mednois=Mednois;
aaout.Stdnois=Stdnois; size(aaout.cands),size(aaout.candr)
figure,semilogy(aaout.cands(1,:),aaout.cands(2,:),'o')
hold on,semilogy(aaout.candr(1,:),aaout.candr(2,:),'ro'),grid on
semilogy(aaout.candn(1,:),aaout.candn(2,:),'kx')

[hs,xs]=hist(log10(aaout.cands(2,:)),50);
[hr,xr]=hist(log10(aaout.candr(2,:)),50);
[hn,xn]=hist(log10(aaout.candn(2,:)),50);
figure,stairs(xs,hs),hold on,stairs(xr,hr,'r'),grid on,stairs(xn,hn,'k')

figure,stairs(hx,aaout.hPsigtot),hold on,stairs(hx,aaout.hPrattot,'r'),grid on
ax=gca;ax.YScale='log';
ntot=sum(aaout.hPsigtot);
cc=rank_pdf(hx,nant,ntot);
hold on,semilogy(hx,cc,'g'),semilogy(hx,cc,'g.')
aaout.chi2tot=cc;
aaout.chi2=cc*N/ntot;
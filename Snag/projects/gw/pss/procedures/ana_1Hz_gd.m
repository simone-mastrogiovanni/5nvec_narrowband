function [tsol tsid sp1 par sp gin]=ana_1Hz_gd(gin,thr,band,SM,long,ic)
%
%   fr    start 1 Hz frequency 
%   str   name string (e.g. 'othraw')
%   thr   threshold
%   band  [frin frfin]
%   SM    science mode list ((2,:), sorted; ex.: VSR2_SM) or 0
%   long  antenna longitude 
%   ic    =1 more, > 1 sub-periods of ic days, array subperiods lengths

persid=86400/1.002737909350795;

if ~exist('ic','var')
    ic=0;
end

n=n_gd(gin);
par.band=band;
par.n0=n;
par.cut0=1-length(find(y_gd(gin)))/n;

cont=cont_gd(gin);
t0=cont.t0;
t1=t0;
dt=dx_gd(gin)/86400;
    
[i1 i2]=size(SM);
if i1 > 1
    y=y_gd(gin);
    k1=1;
    for i = 1:i2
        k2=round((SM(1,i)-t0)/dt)-1;
        if k2 > n
            continue
        end
        y(k1:k2)=0;
        k1=round((SM(2,i)-t0)/dt)+1;
        if k1 < 1
            k1=1;
        end
    end
    gin=edit_gd(gin,'y',y);
    par.cutSM=1-length(find(y))/n;%n=n_gd(gin)
end
gin=rough_clean(gin,-thr,thr,60);
% eval(['gin=rough_clean(' str str1 ',-thr,thr,60)']);
par.cutclean=1-length(find(y_gd(gin)))/n;

if length(ic) > 1
    NN=length(ic);
    ndat=ic*86400;
    close
    sp=0;
else
    if ic == 1 
        sp=gd_pows(gin,'pieces',10000,'window',2,'resolution',2);
    else
        close
        sp=0;
    end

    if ic > 1
        Ndays=ic;
        ndat0=round(Ndays*86400/dx_gd(gin));
        NN=floor(n_gd(gin)/ndat0);
        ndat=ones(NN,1)*ndat0;
    else
        NN=1;
        ndat=0;
    end
end

gdcell=multi_extr(gin,band);
i1=1; % NN,ndat

for jj = 1:NN
    gin=gdcell{1}
    if NN > 1
        gin=gin(i1:i1+ndat(jj)-1);
        i1=i1+ndat(jj);
        t1=t0+(i1-1)*dt;
    end
    
    ph=gmst(t1)*15+long;
    
    [tsol.base tsol.harm tsol.fit tsol.win]=gd_period(abs(gin),'sday',120,4);
    [tsid.base tsid.harm tsid.fit tsid.win]=gd_period(abs(gin),'ssid',120,4,ph);

    perclsol=y_gd(tsol.fit);
    par.asolmax=max(perclsol)-min(perclsol);
    par.asolstd=std(perclsol);
    [a i]=max(perclsol);
    par.hsol=24*i/length(perclsol);

    perclsid=y_gd(tsid.fit);
    par.asidmax=max(perclsid)-min(perclsid);
    par.asidstd=std(perclsid);
    [a i]=max(perclsid);
    par.hsid=24*i/length(perclsid);
    par.len=n_gd(gin);

    gin=edit_gd(gin,'dx',1/86400,'ini',0);
    p.red=100;
    [sp1 sp4 spall]=gd_nud_spec(abs(gin),[0 3.1],8,p);
    
    if NN > 1
        ctsol{jj}=tsol;
        ctsid{jj}=tsid;
        csp1{jj}=sp1;
        cpar{jj}=par;
    end
end

if NN > 1
    tsol=ctsol;
    tsid=ctsid;
    sp1=csp1;
    par=cpar;
end
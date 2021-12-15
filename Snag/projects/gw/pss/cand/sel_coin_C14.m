function [selind bsel spotind h1 h2]=sel_coin_C14(coin,crit,ncand,lists)
%
%     [selind bsel spotind]=sel_coin_C14(coin,crit,ncand,lists)
%
%   coin     coincidence structure
%   crit     criteria {num par1 par2 ...}:
%             1   holes       par1: robstat's p (typically 0.30)
%                             par2: 1 global
%             2   consistency par1: confidence (higher -> larger interval)
%             3   amp sum     par1: pthresh (ex.:0.05)
%                             par2: 1 weighted sum 
%                             par3: 1 global
%             4   numerosity  par1 min
%                             par2 max
%             5   veto
%            10   sort        par1: 1 on A, 2 on h
%            11   smart sort  based on A, h, veto, possible source,...
%            12   subbands    par1: subband width (if no subbands, global equal local)
%            13   frequency   par1,par2: min, max fr
%            20   no plot     par1: level 1,2
%   ncand    number of candidates per subband to select (higher h or A or smart)
%   lists    veto and sources lists
%              veto1
%              veto2
%              sources
%              other
%
%
%   selind   coincidence indices
%   bsel     cell array with coincidence indices per sub-bands
%   spotind  selind indices for spot cands
%
% ex: [selind bsel spotind]=sel_coin_C14(coin_1_100110_C14,{[1,0.3 1],[2,0.8],[3,0.05 0 1],[10,1],[12,1.0],[20 1]},2);
%
% ex. sel sour: [selind bsel spotind]=sel_coin_C14(coin_1_050060_C14,{[1,0.3 1],[2,0.9],[3,0.10,0,1],[10,1],[13,52.80,52.816],[20 1]},30);

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca & Sabrina D'Antonio - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

bsel={};

fr0=coin.stat(1,:);
dfr0=fr0(2)-fr0(1);
frmin=fr0(1)-dfr0/2;
frmax=fr0(length(fr0))+dfr0/2;
ncrit=length(crit);

[fr,lam,bet,sd,A,h,d,num,dlam,dbet]=extr_coin_C14(coin);

A1=A(1,:);
f1=fr(1,:);
n1=num(1,:);
h1=h(1,:);
l1=lam(1,:);
b1=bet(1,:);
sd1=sd(1,:);;

A2=A(2,:);
f2=fr(2,:);
n2=num(2,:);
h2=h(2,:);
l2=lam(2,:);
b2=bet(2,:);
sd2=sd(2,:);

m=robstat(A1,0.5);
muA1=m(1);
m=robstat(A2,0.5);
muA2=m(1);

N0=length(A1);
jj=zeros(1,N0);

sortpar=1;
nbands=1;
sorts='A';
icglob1=0;
icglob3=0;
icplot=2;
numin=1;
numax=1000000;
sbw=(frmax-frmin);

fprintf('\nSEL_COIN:  %d coincidences  fr = [%.2f,%.2f]  spotted cands per s.band %d\n\n',N0,frmin,frmax,ncand)

% PRESET

for i = 1:ncrit
    vcrit=crit{i};
    switch vcrit(1)
        case 1
            glo='local';
            if length(vcrit) > 2
                if vcrit(3) == 1
                    glo='global';
                    icglob1=1;
                end
            end
            scrit=sprintf('holes: cut at p = %.3f %s',vcrit(2),glo);
            
            m=robstat(A1,vcrit(2));
            thresh1=m(3);
            m=robstat(A2,vcrit(2));
            thresh2=m(3);
        case 2
            scrit=sprintf('consistency: at confidence %.3f',vcrit(2));
        case 3 
            wei='no weighted';
            if length(vcrit) > 2
                if vcrit(3) == 1
                    wei='weighted';
                end
            end
            glo='local';
            if length(vcrit) > 3
                if vcrit(4) == 1
                    glo='global';
                    icglob3=1;
                end
            end
            scrit=sprintf('amp sum: p-thresh %.3f  %s  %s',vcrit(2),wei,glo);
            
            pthresh=vcrit(2);
            c1=1;c2=1;
            if length(vcrit) > 2
                if vcrit(3) == 1
                    c1=muA1;c2=muA2;
                end
            end
        case 4
            numin=vcrit(2);
            numax=vcrit(3);
            scrit=sprintf('numerosity: min %d, max %d',numin,numax);
        case 10
            sortpar=vcrit(2);
            if sortpar == 2
                sorts='h';
            end
            scrit=sprintf('sort on %s',sorts);
        case 12
            sbw=vcrit(2);
            scrit=sprintf('%.2f Hz subbands',sbw);
        case 13
            fr_min=vcrit(2);
            fr_max=vcrit(3);
            scrit=sprintf('frequency band %.5f - %.5f',fr_min,fr_max);
        case 20
            icplot=vcrit(2);
            scrit=sprintf('plotting level %d',vcrit(2));
    end
    fprintf('Criterium %d: "%s"  pars ',vcrit(1),scrit)
    for j = 2:length(vcrit)
        fprintf('  %f',vcrit(j))
    end
    fprintf('\n')
end

nbands=round((frmax-frmin)/sbw);
Dfr=(frmax-frmin)/nbands;
frb(1,:)=frmin+Dfr*(0:nbands-1);
frb(2,:)=frb(1,:)+Dfr;

bandstr=sprintf(' Band (%.2f-%.2f) Hz ',frmin,frmax);

fprintf('\n')

if ~exist('ncand','var')
    ncand=ceil(10/nbands);
end

% SELECTION

for k = 1:nbands
    kkk=find(f1 >= frb(1,k) & f1 < frb(2,k));
    Nk=length(kkk);
    bn1=n1(kkk);
    bn2=n2(kkk);
    bA1=A1(kkk);
    bA2=A2(kkk);
    bh1=h1(kkk);
    bh2=h2(kkk);
    bf1=f1(kkk);
    bf2=f2(kkk);
    fprintf('Band %d: (%.2f-%.2f) Hz   %d coincidences\n',k,frb(:,k),Nk);
    jjj=zeros(1,N0);
    jjj(kkk)=1;
    jj(kkk)=1;
    for i = 1:ncrit
        vcrit=crit{i};
        switch vcrit(1)
            case 1
                if icglob1 == 0    
                    m=robstat(bA1,vcrit(2));
                    thresh1=m(3);
                    m=robstat(bA2,vcrit(2));
                    thresh2=m(3);
                end
                ii3=find(bA1 < thresh1);
                ii4=find(bA2 < thresh2);
                if icplot > 1
                    figure,plot(bf1,bA1,'.'),hold on,grid on,plot(bf1(ii3),bA1(ii3),'r.')
                    figure,plot(bf2,bA2,'.'),hold on,grid on,plot(bf2(ii4),bA2(ii4),'g.')
                end
                jjj(kkk(ii3))=0;
                jjj(kkk(ii4))=0;
                jj(kkk(ii3))=0;
                jj(kkk(ii4))=0;
                N1a=N0-length(ii3); 
                N=sum(jjj);
                fprintf('Selection type 1: group 1 %d cut, group 2 %d cut\n',length(ii3),length(ii4))
                fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jjj),sum(jjj)/Nk)
            case 2
                kconf=norminv(1-(1-vcrit(2))/2,0,1);
                h11=bh1.*(1-kconf./sqrt(bA1));
                h12=bh1.*(1+kconf./sqrt(bA1));
                h21=bh2.*(1-kconf./sqrt(bA2));
                h22=bh2.*(1+kconf./sqrt(bA2));
                ii1=find((h21 > h12 | h11 > h22));
                jjj(kkk(ii1))=0;
                jj(kkk(ii1))=0;
                N2=N0-length(ii1); 
                N=N0-length(ii1); 
%                 figure,hist(bA1+bA2,200);
                fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jjj),sum(jjj)/Nk)
            case 3
                if icglob3 == 0
                    c1=1;c2=1;
                    if length(vcrit) > 2
                        if vcrit(3) == 1
                            m=robstat(bA1,0.5);
                            c1=m(1);
                            m=robstat(bA2,0.5);
                            c2=m(1);
                        end
                    end
                end
                thresh=prctile(bA1/c1+bA2/c2,100*(1-pthresh));
                ii2=find(bA1/c1+bA2/c2 < thresh);
                jjj(kkk(ii2))=0;
                jj(kkk(ii2))=0;
                N3=N0-length(ii2); 
                N=N0-length(ii2); 
                fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jjj),sum(jjj)/Nk)
            case 4
                ii5=find(bn1 < numin | bn1 > numax | bn2 < numin | bn2 > numax);
                jjj(kkk(ii5))=0;
                jj(kkk(ii5))=0;
                fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jjj),sum(jjj)/Nk)
            case 13
                ii6=find(bf1 < fr_min | bf1 > fr_max & bf2 < fr_min | bf2 > fr_max);
                jjj(kkk(ii6))=0;
                jj(kkk(ii6))=0;
                fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jjj),sum(jjj)/Nk)
        end
    end
    
    bsel{k}=find(jjj);
end

selind=find(jj);
NN=length(selind);

fprintf('Total selection : %d survived (%f)\n',NN,sum(jj)/N0)

fprintf('\n')
% figure,plot(f1(selind),selind,'X'),hold on,plot(f1(bsel{4}),bsel{4},'r.')
% return
ic=0;
spot=[];

% SPOT

for k = 1:nbands
    sel=bsel{k};
    if length(sel) > 0
        switch sortpar
            case 1
                hh0=(A1(sel)+A2(sel))/2;
                [hh,ii]=sort(hh0,'descend');
            case 2
                hh0=(h1(sel)+h2(sel))/2;
                [hh,ii]=sort(hh0,'descend');
        end

        for i = 1:min(length(ii),ncand)
            ic=ic+1;
            iii=sel(ii(i));
            fprintf(' spot %d Sub-band %d: coincidence %d  distance %f\n',ic,k,iii,d(iii))
            [ao,do]=astro_coord('ecl','equ',l1(iii),b1(iii));
            fprintf('cl1: %d %f %.2e (%.1f,%.1f) (eq %.1f,%.1f) %.1f %.2e \n',n1(iii),f1(iii),sd1(iii),...
                l1(iii),b1(iii),ao,do,A1(iii),h1(iii))
            [ao,do]=astro_coord('ecl','equ',l2(iii),b2(iii));
            fprintf('cl1: %d %f %.2e (%.1f,%.1f) (eq %.1f,%.1f) %.1f %.2e \n',n2(iii),f2(iii),sd2(iii),...
                l2(iii),b2(iii),ao,do,A2(iii),h2(iii))
            spot=[spot iii];
        end
    end
end

[C,spotind,iB]=intersect(selind,spot);

% figure,plot(spotind,'.'),grid on
% figure,plot(selind,'r.'),grid on
clear A

if icplot > 0
    A(:,1)=n1(selind);
    A(:,2)=n2(selind);
    A(:,3)=(A1(selind)+A2(selind))/2;
    color_points_1(A,0,spotind),title(['Num2 vs Num1 (A in color)' bandstr])
    
    A(:,1)=A1(selind);
    A(:,2)=A2(selind);
    A(:,3)=f1(selind);
    color_points_1(A,0,spotind),title(['A2 vs A1 (fr in color)' bandstr])

    A(:,1)=h1(selind);
    A(:,2)=h2(selind);
    A(:,3)=f1(selind);
    color_points_1(A,0,spotind),title(['h2 vs h1 (fr in color)' bandstr])

    A(:,1)=(f1(selind)+f2(selind))/2;
    A(:,2)=(sd1(selind)+sd2(selind))/2;
    A(:,3)=(h1(selind)+h2(selind))/2;
    color_points_1(A,0,spotind),title(['sd vs fr (h in color)' bandstr])

    A(:,1)=(f1(selind)+f2(selind))/2;
    A(:,2)=(A1(selind)+A2(selind))/2;
    A(:,3)=(h1(selind)+h2(selind))/2;
    color_points_1(A,0,spotind),title(['A vs fr (h in color)' bandstr])
    
    A(:,1)=(A1(selind)+A2(selind))/2;
    A(:,2)=(h1(selind)+h2(selind))/2;
    A(:,3)=(f1(selind)+f2(selind))/2;
    color_points_1(A,0,spotind),title(['h vs A (fr in color)' bandstr])

    A(:,1)=(f1(selind)+f2(selind))/2;
    A(:,2)=(h1(selind)+h2(selind))/2;
    A(:,3)=(A1(selind)+A2(selind))/2;
    color_points_1(A,0,spotind),title(['h vs fr (A in color)' bandstr])

    [hh,fh]=hist((f1(selind)+f2(selind))/2,600);
    figure,stairs(fh,hh),grid on,title(['histogram on freq' bandstr])

    A(:,1)=(l1(selind)+l2(selind))/2;
    A(:,2)=(b1(selind)+b2(selind))/2;
    A(:,3)=(h1(selind)+h2(selind))/2;
    color_points_1(A,0,spotind),title(['beta vs lambda (h in color)' bandstr])

    [al de]=astro_coord('ecl','equ',(l1(selind)+l2(selind))/2,(b1(selind)+b2(selind))/2);
    A(:,1)=al;
    A(:,2)=de;
    A(:,3)=(h1(selind)+h2(selind))/2;
    color_points_1(A,0,spotind),title(['delta vs alpha (h in color)' bandstr])
end

function selind=sel_coin(coin,crit,ncand,lists)
%
%     cout=sel_coin(coin,num,w,fr,lam,bet,amp)
%
%   coin     coincidence structure
%   crit     criteria {num par1 par2 ...}:
%             1   holes       par1: robstat's p (typically 0.30)
%                             par2: 1 global
%             2   consistency par1: confidence (higher -> larger interval)
%             3   amp sum     par1: pthresh (ex.:0.05)
%                             par2: 1 weighted sum 
%                             par3: 1 global
%             4   veto
%            10   sort        par1: 1 on A, 2 on h
%            11   smart sort  based on A, h, veto, possible source,...
%            12   subbands    par1: number (if no subbands, global equal local)
%   ncand    number of candidates to select (higher h)
%   lists    veto and sources lists
%              veto1
%              veto2
%              sources
%              other
%
% ex: selind=sel_coin(coin_1_010030_ref,{[1,0.3],[2,0.8],[3,0.05]},4);

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca & Sabrina D'Antonio - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ncand','var')
    ncand=10;
end
fr0=coin.stat(1,:);
dfr0=fr0(2)-fr0(1);
frmin=fr0(1)-dfr0/2;
frmax=fr0(length(fr0))+dfr0/2;
ncrit=length(crit);
A1=coin.cand1(coin.cref(:,2),5);
A2=coin.cand2(coin.cref(:,3),5);
muA1=robstat(A1,0.5);
muA2=robstat(A2,0.5);
h1=coin.cand1(coin.cref(:,2),9);
h2=coin.cand2(coin.cref(:,3),9);
f1=coin.cand1(coin.cref(:,2),1);
f2=coin.cand2(coin.cref(:,3),1);
l1=coin.cand1(coin.cref(:,2),2);
l2=coin.cand2(coin.cref(:,3),2);
b1=coin.cand1(coin.cref(:,2),3);
b2=coin.cand2(coin.cref(:,3),3);
sd1=coin.cand1(coin.cref(:,2),4);
sd2=coin.cand2(coin.cref(:,3),4);
N0=length(A1);
jj=ones(1,N0);

sortpar=1;
nbands=1;
sorts='A';

fprintf('\nSEL_COIN:  %d coincidences  fr = [%.2f,%.2f]  \n\n',N0,frmin,frmax)

for i = 1:ncrit
    vcrit=crit{i};
    switch vcrit(1)
        case 1
            glo='local';
            if length(vcrit) > 2
                if vcrit(3) == 1
                    glo='global';
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
        case 10
            sorts='A';
            sortpar=vcrit(2);
            if sortpar == 2
                sorts='h';
            end
            scrit=sprintf('sort on %s',sorts);
        case 12
            nbands=vcrit
            scrit=sprintf('%d subbands',nbands);
    end
    fprintf('Criterium %d: "%s"  pars ',vcrit(1),scrit)
    for j = 2:length(vcrit)
        fprintf('  %f',vcrit(j))
    end
    fprintf('\n')
end

fprintf('\n')

for i = 1:ncrit
    vcrit=crit{i};
    switch vcrit(1)
        case 1
            ii3=find(A1 < thresh1);
            ii4=find(A2 < thresh2);
            figure,plot(f1,A1,'.'),hold on,grid on,plot(f1(ii3),A1(ii3),'r.')
            figure,plot(f2,A2,'.'),hold on,grid on,plot(f2(ii4),A2(ii4),'r.')
            jj(ii3)=0;
            jj(ii4)=0;
            N1a=N0-length(ii3); 
            N=sum(jj);
            fprintf('Selection type 1: 1 %d cut, 2 %d cut\n',length(ii3),length(ii4))
            fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jj),sum(jj)/N0)
        case 2
            kconf=norminv(1-(1-vcrit(2))/2,0,1);
            h11=h1.*(1-kconf./sqrt(A1));
            h12=h1.*(1+kconf./sqrt(A1));
            h21=h2.*(1-kconf./sqrt(A2));
            h22=h2.*(1+kconf./sqrt(A2));
            ii1=find((h21 > h12 | h11 > h22));
            jj(ii1)=0;
            N2=N0-length(ii1); 
            N=N0-length(ii1); 
            figure,hist(A1+A2,200);
            fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jj),sum(jj)/N0)
        case 3
            thresh=prctile(A1/c1+A2/c2,100*(1-pthresh));
            ii2=find(A1/c1+A2/c2 < thresh);
            jj(ii2)=0;
            N3=N0-length(ii2); 
            N=N0-length(ii2); 
            fprintf('Selection %d, type %d: %d survived (%f)\n',i,vcrit(1),sum(jj),sum(jj)/N0)
    end
end

selind=find(jj);
NN=length(selind);

fprintf('Total selection : %d survived (%f)\n',NN,sum(jj)/N0)

fprintf('\n')

switch sortpar
    case 1
        hh0=(A1(selind)+A2(selind))/2;
        [hh,ii]=sort(hh0,'descend');
    case 2
        hh0=(h1(selind)+h2(selind))/2;
        [hh,ii]=sort(hh0,'descend');
end

for i = 1:ncand
    iii=selind(ii(i));
    cand1=coin.cand1(coin.cref(iii,2),:);
    cand2=coin.cand2(coin.cref(iii,3),:);
    fprintf(' coincidence %d  distance %f\n',iii,coin.cref(iii,1))
    [ao,do]=astro_coord('ecl','equ',cand1(2),cand1(3));
    fprintf('cl1: %d %f %.2e (%.1f,%.1f) (eq %.1f,%.1f) %.1f %.2e \n',coin.clust1(1,iii),cand1(1),cand1(4),...
        cand1(2),cand1(3),ao,do,cand1(5),cand1(9))
    [ao,do]=astro_coord('ecl','equ',cand2(2),cand2(3));
    fprintf('cl2: %d %f %.2e (%.1f,%.1f) (eq %.1f,%.1f) %.1f %.2e \n',coin.clust2(1,iii),cand2(1),cand2(4),...
        cand2(2),cand2(3),ao,do,cand2(5),cand2(9))
end

spotind=ii(1:ncand);

A(:,1)=A1(selind);
A(:,2)=A2(selind);
A(:,3)=f1(selind);
color_points_1(A,0,spotind),title('A2 vs A1 (fr in color)')

A(:,1)=h1(selind);
A(:,2)=h2(selind);
A(:,3)=f1(selind);
color_points_1(A,0,spotind),title('h2 vs h1 (fr in color)')

A(:,1)=(f1(selind)+f2(selind))/2;
A(:,2)=(sd1(selind)+sd2(selind))/2;
A(:,3)=(h1(selind)+h2(selind))/2;
color_points_1(A,0,spotind),title('sd vs fr (h in color)')

A(:,1)=(f1(selind)+f2(selind))/2;
A(:,2)=(A1(selind)+A2(selind))/2;
A(:,3)=(h1(selind)+h2(selind))/2;
color_points_1(A,0,spotind),title('A vs fr (h in color)')

A(:,1)=(f1(selind)+f2(selind))/2;
A(:,2)=(h1(selind)+h2(selind))/2;
A(:,3)=(A1(selind)+A2(selind))/2;
color_points_1(A,0,spotind),title('h vs fr (A in color)')

[hh,fh]=hist((f1(selind)+f2(selind))/2,600);
figure,stairs(fh,hh),grid on,title('histogram on freq')

A(:,1)=(l1(selind)+l2(selind))/2;
A(:,2)=(b1(selind)+b2(selind))/2;
A(:,3)=(h1(selind)+h2(selind))/2;
color_points_1(A,0,spotind),title('beta vs lambda (h in color)')

[al de]=astro_coord('ecl','equ',(l1(selind)+l2(selind))/2,(b1(selind)+b2(selind))/2);
A(:,1)=al;
A(:,2)=de;
A(:,3)=(h1(selind)+h2(selind))/2;
color_points_1(A,0,spotind),title('delta vs alpha (h in color)')

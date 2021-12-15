function out=hfdf_anacand(cand,typ,sour)
% rough analysis of candidates
%
%   cand    9 or 15 candidate matrix
%   typ     [typ styp] :
%             typ  type of analysis (1 -> raw, 2 -> refined, 3 -> difference)
%             styp (if present) sub-type (1 primary, 2 secondary, 0 all)
%   sour    source list cell array use as:
%            >> ps_source_list
%            >> hfdf_anacand(cand,2,ps_s_l)

% Version 2.0 - November 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

out=struct();

if isstruct(cand)
    if isfield(cand,'job_summary')
        cand_level='job';
        info=cand.job_summary;
        jobname=info.jobname;
    end
    if isfield(cand,'info')
        cand_level='run';
        info=cand.info;
    end
    cand=cand.cand;
    dsd=info.sd.dnat/info.mode.ref.sd.enh;
    sdmin=info.sd.min+dsd*info.mode.ref.sd.min;
    sdmax=info.sd.max+dsd*info.mode.ref.sd.max;
    hsd=sdmin:dsd:sdmax+dsd/10;
else
    sdmin=min(cand(4,:));
    sdmax=max(cand(4,:));
    xx=unique(cand(4,:));
    xx=sort(xx);
    dsd=min(diff(xx));
    hsd=100;
    jobname='NO';
end

if ~exist('typ','var')
    typ=2;
    styp=0;
end

if length(typ) == 2
    styp=typ(2);
    typ=typ(1);
end

if ~exist('styp','var')
    styp=0;
end

switch styp
    case 1
        ii=find(cand(9,:) == 1);
        cand=cand(:,ii);
    case 2
        ii=find(cand(9,:) == 2);
        cand=cand(:,ii);
end

[nrow M]=size(cand);

[aa,ii]=max(cand(5,:));
out.maxraw=cand(:,ii);

if nrow == 9
    typ=1;
    fprintf('max RAW (cand %d) %.6f %.2f %.2f %.3e %.1f %.2f %.2f %.2f %d \n',...
        ii,cand(1:9,ii));
else
    fprintf('max RAW (cand %d) %.6f %.2f %.2f %.3e %.1f %.2f %.2f %.2f %d \n                     %.6f %.2f %.2f %.3e %.1f %.2f \n',...
        ii,cand(1:9,ii),cand(10:15,ii));
    [aa,ii]=max(cand(14,:));
    out.maxref=cand(:,ii);
    fprintf('max REF (cand %d) %.6f %.2f %.2f %.3e %.1f %.2f %.2f %.2f %d \n                     %.6f %.2f %.2f %.3e %.1f %.2f \n',...
        ii,cand(1:9,ii),cand(10:15,ii));
end

bias=0;
switch typ
    case 2
        bias=9;
    case 3
        cand(1:6,:)=cand(10:15,:)-cand(1:6,:);
end

if typ == 3
    p1(:,1)=cand(10,:);
else
    p1(:,1)=cand(1+bias,:);
end
p1(:,2)=cand(2+bias,:);
p1(:,3)=cand(5+bias,:);
color_points(p1,0,{'candidate amplitude' 'Hz' '\lambda' 'rO'});
%xlim([min(p1(:,1)) max(p1(:,1))]);


p1(:,2)=cand(4+bias,:);
color_points(p1,0,{'candidate amplitude' 'Hz' 'sd' 'rO'});
%xlim([min(p1(:,1)) max(p1(:,1))]);

clear p1
ii=find(~isnan(cand(6+bias,:)) & ~isinf(cand(6+bias,:)));

p1(:,3)=cand(6+bias,ii);
if typ == 3
    p1(:,1)=cand(10,ii);
else
    p1(:,1)=cand(1+bias,ii);
end
p1(:,2)=cand(2+bias,ii);
color_points(p1,0,{'candidate CR' 'Hz' '\lambda' 'rO'});

[h x]=hist(cand(1+bias,:),500);
figure,stairs(x,h),grid on
title('frequency histogram')

[h x]=hist(cand(2+bias,:),360);
figure,stairs(x,h),grid on
title('lambda histogram')

[h x]=hist(cand(3+bias,:),1800);
figure,stairs(x,h),grid on
title('beta histogram')

[h x]=hist(cand(4+bias,:),hsd);
figure,stairs(x,h),grid on
title('sd histogram')
% clear p1

if typ == 2
    figure,plot(cand(4,:),cand(13,:),'.'),grid on
    hh=unique(cand(4,:));length(hh)
%     for i = 1:length(hh)
%         ii=find(cand(4,:) == hh(i));
%         figure,hist(cand(13,ii),200);
%     end
end

[h x]=hist(cand(5+bias,:),400);
figure,stairs(x,h),grid on
title('amp histogram')


[h x]=hist(cand(6+bias,:),400);
figure,semilogy(x,h),grid on
title('CR histogram')

% ii=find(isnan(cand(6,:)));
% p1(:,3)=cand(5,ii);
% p1(:,1)=cand(1,ii);
% p1(:,2)=cand(2,ii);
% color_points(p1,0,{'candidate CR=NaN' 'Hz' '\lambda' 'rO'})
% out.nNaN=length(ii);
% 
% clear p1
% ii=find(isinf(cand(6,:)));
% p1(:,3)=cand(5,ii);
% p1(:,1)=cand(1,ii);
% p1(:,2)=cand(2,ii);
% color_points(p1,0,{'candidate CR=Inf' 'Hz' '\lambda' 'rO'})
% out.nInf=length(ii);

fr=cand(1+bias,:);
figure,plot(fr,'.'),grid on
title('frequencies')
xlim([1 length(fr)])
ylim([min(fr) max(fr)])

d=diff(fr);
ii=find(d >= 0);
[h x]=hist(d(ii),100);
figure,stairs(x,h),grid on
title('frequency differences (neighbours)')

fr=sort(fr);
[h x]=hist(diff(fr),200);
figure,semilogy(x,h),grid on
title('frequency differences (with sort)')

if exist('sour','var')
    ns=length(sour);
    fr1=min(fr)-0.2;
    fr2=max(fr)+0.2;fr1,fr2
    if strcmp(jobname,'NO')
        epoch=0;
    else
        out=dec_jobname(jobname);
        epoch=out.run.epoch;
        dfr=out.run.fr.dnat;
        dsd=out.run.sd.dnat;
    end
    
    coin=zeros(4,M);
    ncoin=0;
    inis=1;
    
    for i = 1:ns
        ss=sour{i};
        if epoch > 0
            ss=new_posfr(ss,epoch);
        end
        if ss.f0 > fr1 && ss.f0 < fr2
            [lam bet]=astro_coord('equ','ecl',ss.a,ss.d);
            P=[ss.f0 lam bet ss.df0];
            for j = 1:M
                erraw(1)=(cand(1,j)-ss.f0)/dfr;
                erraw(2)=(cand(2,j)-lam)/(cand(7,j)*2);
                erraw(3)=(cand(3,j)-bet)/(cand(8,j)*2);
                erraw(4)=(cand(4,j)-ss.df0)/dsd;
                erref(1)=(cand(1+9,j)-ss.f0)/dfr;
                erref(2)=(cand(2+9,j)-lam)/(cand(7,j)*2);
                erref(3)=(cand(3+9,j)-bet)/(cand(8,j)*2);
                erref(4)=(cand(4+9,j)-ss.df0)/dsd;
                Erraw=sqrt(sum(erraw.^2));
                Erref=sqrt(sum(erref.^2));
                if Erraw < 3 | Erref < 3
                    ncoin=ncoin+1;
                    coin(1,ncoin)=i;
                    coin(2,ncoin)=j;
                    coin(3,ncoin)=Erraw;
                    coin(4,ncoin)=Erref;
%                     fprintf('%d %d %d %f %f \n',ncoin,coin(:,ncoin));
                    fprintf('Source  %.6f %.2f %.2f %e  \n',ss.f0,lam,bet,ss.df0);
                    fprintf('Raw     %.6f %.2f %.2f %e  %.01f %.02f\n',cand(1:6,j));
                    fprintf('  err     %.2f       %.2f   %.2f %.2f          %.2f \n',erraw,Erraw);
                    fprintf('Ref     %.6f %.2f %.2f %e  %.01f %.02f\n',cand(1:6,j));
                    fprintf('  err     %.2f       %.2f   %.2f %.2f          %.2f \n',erref,Erref);
                    fprintf('            Min err %f   Ref. gain %f \n',min(Erraw,Erref),Erraw/Erref);
                end
            end
            cc=min(coin(3,inis:ncoin),coin(4,inis:ncoin));
            [minerr imin]=min(cc);
            jj=coin(2,imin);
            if isempty(jj)
                fprintf('no coincidence with source %d \n',i)
            else
                erraw(1)=(cand(1,jj)-ss.f0)/dfr;
                erraw(2)=(cand(2,jj)-lam)/(cand(7,j)*2);
                erraw(3)=(cand(3,jj)-bet)/(cand(8,j)*2);
                erraw(4)=(cand(4,jj)-ss.df0)/dsd;
                erref(1)=(cand(1+9,jj)-ss.f0)/dfr;
                erref(2)=(cand(2+9,jj)-lam)/(cand(7,j)*2);
                erref(3)=(cand(3+9,jj)-bet)/(cand(8,j)*2);
                erref(4)=(cand(4+9,jj)-ss.df0)/dsd;
                Erraw=sqrt(sum(erraw.^2));
                Erref=sqrt(sum(erref.^2));
                fprintf('\n   Best Matching job %s  source %d \n',jobname,i)
                fprintf('                 candidate %d \n',jj)
                fprintf('        frequency  lambda   beta   spin-down     amp      CR\n')
                fprintf('Source  %.6f %.2f %.2f %e  \n',ss.f0,lam,bet,ss.df0);
                fprintf('Raw     %.6f %.2f %.2f %e   %.01f  %.02f\n',cand(1:6,jj));
                fprintf('  err     %.2f    %.2f   %.2f   %.2f         %.2f \n',erraw,Erraw);
                fprintf('Ref     %.6f %.2f %.2f %e  %.01f %.02f\n',cand(10:15,jj));
                fprintf('  err     %.2f    %.2f   %.2f   %.2f         %.2f \n',erref,Erref);
                fprintf('            Min err %f   Ref. gain %f \n',min(Erraw,Erref),Erraw/Erref);
                inis=ncoin+1;
            end
        end
    end
    coin=coin(:,1:ncoin);
    out.coin=coin;
end


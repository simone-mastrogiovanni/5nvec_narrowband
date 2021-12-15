function clust=cand_clust_old(A,par,res)
%
%   clust=cand_clust(A,par,res)
%
%   A    candidate input matrix
%   par  natural resolutions [dfr dsd]
%   res  resolutions (in natural units; def [1 1 1 1])
%
%   clust  output structure array

% Version 2.0 - June 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n1 n2]=size(A);
II=sparse(n1,1);

dfr=par(1)/2;
dsd=par(2)/2;

if ~exist('res','var')
    res=[1 1 1 1];
end

ncheck=50000;
liii=zeros(ncheck,1);
iiii=0;
figure
N=0;
clust=struct('frmin',0,'frmax',0,'fr',0,'dfr',0,...
    'lammin',0,'lammax',0,'lam',0,'dlam',0,...
    'betmin',0,'betmax',0,'bet',0,'dbet',0,...
    'sdmin',0,'sdmax',0,'sd',0,'dsd',0,...
    'ampmax',0,'cr',0,'num',0);
clust0=clust;
clust(1:ncheck/2)=clust0;
cl2=clock;
N1=0;
    
for i = 1:n1
    newclust=1;
    cand1=A(i,:);
    fr=cand1(1);
    III=find(II);
    lenIII=length(III);
    iiii=iiii+1;
    liii(iiii)=lenIII;
    if i == 1
        logfile=sprintf('cand_clust_%03.0f_%d_%d_%d_%d_%d_.log',fr,cl2(1:5));
        fid=fopen(logfile,'w');
    end
    
    dlam=cand1(7);
    dbet=cand1(8);
    if floor(i/ncheck)*ncheck == i    
        cl1=clock;
        sec=etime(cl1,cl2);
        fprintf('%d %d %.3f lenIII=%.0f,%.0f  %d:%d:%.0f %.1f %d\n',i,N,fr,mean(liii),std(liii),cl1(4:6),sec,N-N1);
        fprintf(fid,'%d %d %.3f lenIII=%.0f,%.0f  %d:%d:%.0f %.1f %d\n',i,N,fr,mean(liii),std(liii),cl1(4:6),sec,N-N1);
        h1=min(liii);
        h2=max(liii);
        if h1 == h2
            h1=h1-1;
            h2=h2+1;
        end
        hist(liii,h1:h2)
        iiii=0;
        pause(2)
        cl2=cl1;
        N1=N;
        clust(N+1:N+ncheck/2)=clust0;
    end
    
    if ~isempty(III)
        for jj = 1:lenIII
            ii=III(jj);
            clust1=clust(ii);
            if clust1.frmax < fr-(res(1)-1)*dfr   % Critical
                II(ii)=0;
                continue
            end
            if clust1.lammin-cand1(2)      <= res(2)*dlam && cand1(2)-clust1.lammax <= res(2)*dlam && ...
                    clust1.betmin-cand1(3) <= res(3)*dbet && cand1(3)-clust1.betmax <= res(3)*dbet && ...
                    clust1.sdmin-cand1(4)  <= res(4)*dsd  && cand1(4)-clust1.sdmax  <= res(4)*dsd
                clust(ii).frmax=fr+dfr;
                clust(ii).lammin=min(clust(ii).lammin,cand1(2)-dlam);
                clust(ii).lammax=max(clust(ii).lammax,cand1(2)+dlam);
                clust(ii).betmin=min(clust(ii).betmin,cand1(3)-dbet);
                clust(ii).betmax=max(clust(ii).betmax,cand1(3)+dbet);
                clust(ii).sdmin=min(clust(ii).sdmin,cand1(4)-dsd);
                clust(ii).sdmax=max(clust(ii).sdmax,cand1(4)+dsd);
                clust(ii).num=clust(ii).num+1;
                if cand1(5) > clust1.ampmax
                    clust(ii).ampmax=cand1(5);
                    clust(ii).fr=cand1(1);
                    clust(ii).lam=cand1(2);
                    clust(ii).bet=cand1(3);
                    clust(ii).sd=cand1(4);
                    clust(ii).cr=cand1(6);
                end
                newclust=0;
                break
            end
        end
    end
    
    if newclust == 1
        N=N+1;
        clust(N)=crea_clust(cand1,dfr,dsd,dlam,dbet);
        II(N)=1;
    end
end

fclose(fid)
        
        
function clust=crea_clust(cand1,dfr,dsd,dlam,dbet)

clust.frmin=cand1(1)-dfr;
clust.frmax=cand1(1)+dfr;
clust.fr=cand1(1);
clust.dfr=dfr;
clust.lammin=cand1(2)-dlam;
clust.lammax=cand1(2)+dlam;
clust.lam=cand1(2);
clust.dlam=dlam;
clust.betmin=cand1(3)-dbet;
clust.betmax=cand1(3)+dbet;
clust.bet=cand1(3);
clust.dbet=dbet;
clust.sdmin=cand1(4)-dsd;
clust.sdmax=cand1(4)+dsd;
clust.sd=cand1(4);
clust.dsd=dsd;
clust.ampmax=cand1(5);
clust.cr=cand1(6);
clust.num=1;
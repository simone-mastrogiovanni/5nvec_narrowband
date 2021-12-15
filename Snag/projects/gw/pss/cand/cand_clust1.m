function [clust, serv]=cand_clust(A,dfr,dsd,dist)
% candidate "refined" clustering 
%
%   clust=cand_clust(A,par,res)
%
%   A        candidate input matrix
%   dfr,dsd  natural resolutions (2*unc)
%   dist     clustering distance (def = 2)
%
%   clust  output structure array
%      .index  candidate matrix cluster index (int32)
%      .clust  cluster matrix (num,pointer to cand,frmin,frmax,fr,...)
%      .dist
%      .dfr
%      .dsd
%
%   serv   service matrix
%          serv(1,:)  maxind
%          serv(2,:)  clustered with (0 -> not clustered)
%          serv(3,:)  progenitor
%          serv(4,:)  numerosity (0 for non-progenitors)

% Version 2.0 - July 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ibuf=200000;

[n1, n2]=size(A);

if n2 == 8
    A=A';
else
    n1=n2;
end

dfr2=dfr/2;
dsd2=dsd/2;

if ~exist('dist','var')
    dist=2;
end

serv=zeros(4,n1);

frdist=dist*dfr+dfr2;
j=n1;

for i = n1:-1:1
    while A(1,i)+frdist < A(1,j)
        j=j-1;
    end
    serv(1,i)=j;
end

tot1=0;
tot2=0;
for i = 1:n1
    if i == floor(i/100000)*100000
        s=datestr(now);
        fprintf('f = %f tot1 = %d tot2 = %d %s \n',A(1,i),tot1,tot2,s)
    end
    if serv(2,i) == 0
        serv(2,i)=i;
        tot1=tot1+1;
    end
    ii=i+1:serv(1,i);
    iii=find(serv(2,ii) == 0);
    arr=A(:,ii(iii));
    d=distance(A(:,i),arr,dfr,dsd);%fprintf('%d %f %f \n',length(d),mean(d),std(d))
    iiii=find(d <= dist); % size(ii),size(iii)
    serv(2,ii(iii(iiii)))=i;
    tot2=tot2+length(iiii);
end

icl=find(serv(2,:) == 1:n1);

for i = 1:n1
    ipr=i;
    gen=serv(2,ipr);
    while gen ~= ipr
        ipr=gen;
        gen=serv(2,ipr);
    end
    serv(3,i)=ipr;
end


for i = 1:n1
    serv(4,serv(3,i))=serv(4,serv(3,i))+1;
end

[aa,bb,index]=unique(serv(3,:));
index=int32(index);

ii=find(serv(4,:));

disp('start part 2')

clust0=zeros(18,length(ii));
clust0(1,:)=serv(4,ii);

iii=0;

for i = 1:length(ii)
    if i == floor(i/50000)*50000
        s=datestr(now);
        fprintf('f = %f clust = %d cand = %d  %s \n',A(1,iii),i,iii,s)
    end
    clust0(2,i)=iii+1;
    prog=ii(i);
    progfin=min(prog+ibuf,n1);
    iiii=find(serv(3,prog:progfin) == prog);
    iiii=iiii+prog-1;
    liiii=length(iiii);
    cand1=A(:,iiii);
%     if nobig == 0
%         cand(:,iii+(1:liiii))=cand1;
%     end
    clust0(3,i)=min(cand1(1,:));
    clust0(4,i)=max(cand1(1,:));
    clust0(6,i)=min(cand1(2,:));
    clust0(7,i)=max(cand1(2,:));
    clust0(9,i)=min(cand1(3,:));
    clust0(10,i)=max(cand1(3,:));
    clust0(12,i)=min(cand1(4,:));
    clust0(13,i)=max(cand1(4,:));
    [clust0(15,i),j]=max(cand1(5,:));
    clust0(5,i)=cand1(1,j);
    clust0(8,i)=cand1(2,j);
    clust0(11,i)=cand1(3,j);
    clust0(14,i)=cand1(4,j);
    clust0(16,i)=cand1(6,j);
    clust0(17,i)=mean(cand1(7,:));
    clust0(18,i)=mean(cand1(8,:));
    iii=iii+liiii;
end

clust.clust=clust0;
clust.index=index;
clust.dist=dist;
clust.dfr=dfr;
clust.dsd=dsd;


function d=distance(const,arr,dfr,dsd)

d=sqrt(...
    ((const(1)-arr(1,:))/dfr).^2+...
    ((const(4)-arr(4,:))/dsd).^2+...
    ((const(2)-arr(2,:))./(const(7)+arr(7,:))).^2+...
    ((const(3)-arr(3,:))./(const(8)+arr(8,:))).^2 ...
    );
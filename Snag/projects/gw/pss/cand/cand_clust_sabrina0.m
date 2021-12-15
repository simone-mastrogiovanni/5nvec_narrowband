function [clust, serv]=cand_clust_sabrina(A,dist,dfr,dsd)
% candidate "refined" clustering ("unique" procedure, the old one is cand_clust1)
%
%    [clust, serv]=cand_clust(A,dist,dfr,dsd)
%
%   A        candidate input matrix or struct
%   dist     clustering distance (def = 2)
%   dfr,dsd  natural resolutions (2*unc) - if info not present, otherwise ignored
%
%
%   clust  output structure array
%      .index  candidate matrix cluster index (int32)
%      .clust  cluster matrix (num,weight,frmin,frmax,fr,...)
%      .dist
%      .dfr
%      .dsd
%
%   serv   service matrix
%          serv(1,:)  maxind
%          serv(2,:)  clustered with (0 -> not clustered) = partial clustering
%
%   clust.clust (18,N) or (19,N)
%         1     Numerosity
%         2     weight (sum of the amplitudes)
%         3     min frequency
%         4     max frequency
%         5     Frequency
%         6     min lambda
%         7     max lambda
%         8     lambda
%         9     min beta
%         10	max beta
%         11	beta
%         12	min spin-down
%         13	max spin-down
%         14	spin-down
%         15	Amplitude
%         16	CR
%         17	mean uncertainty on  lambda  (semi-interval)
%         18	mean uncertainty on  beta  (semi-interval)
%         19	h-Amplitude (if it exists)

% Version 2.0 - July 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

if isstruct(A)
    info=A.info;
    dfr=info.run.fr.dnat;
    dsd=info.run.sd.dnat;
    A=A.cand;
    clust.info=info;
end

[n1, n2]=size(A)

if n2 == 8 | n2 == 9
    A=A';
else
    n1=n2;
end

dfr2=dfr/2;

if ~exist('dist','var')
    dist=2;
end

serv=zeros(2,n1);

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
% n1=1000000
funt=tic;
for i = 1:n1
    if i == floor(i/100000)*100000
        s=datestr(now);
        fprintf('f = %f tot1 = %d tot2 = %d %s \n',A(1,i),tot1,tot2,s)
    end
    ii=i+1:serv(1,i);
    Dlam=A(2,i)-A(2,ii);
    d=(sqrt(...
        ((A(1,i)-A(1,ii))/dfr).^2+...
        ((A(4,i)-A(4,ii))/dsd).^2+...
        (min(mod(Dlam,360),mod(-Dlam,360))./((A(7,i)+A(7,ii)))).^2+...
        ((A(3,i)-A(3,ii))./((A(8,i)+A(8,ii)))).^2 ...
        ));
    clear k
    k=find(d <= dist);
    if ~isempty(k)>0
        w=find(serv(2,ii(k))); % find the serv(2,ii(k)) filled
        if isempty(w)==0 % all serv to be filled
             if serv(2,i)==0
                serv(2,i)=i;
                serv(2,ii(k))=i;
                tot1=tot1+1;
                AA{i}=unique([ii(k),i]);% positions of candidates in the cluster i
             else   % serv(2,i) is filled 
                serv(2,ii(k))=serv(2,i); % fill the empty serv(2,(ii(k)) with serv(2,i) 
                IND=AA{serv(2,i)};% Upload A : in A the old plus the new candidates (ii(k)) in the cluster serv(2,i)
                newInd=union(IND,ii(k));
                AA{serv(2,i)}=newInd;
                clear IND newInd
            end
        else % length(w)>0 % some serv are  filled
            if serv(2,i)==0
                M=min(serv(2,ii(k(w)))); % ii(k(w)) indice dei serv gia riempiti
            else
                M=min(serv(2,i),min(serv(2,ii(k(w)))));
            end
            % Update AA
            IND=[];
            for j=1:length(ii(k(w)))
                IND=[AA{serv(2,ii(k(w(j))))},IND];
                AA{serv(2,ii(k(w(j))))}=[]; % clear AA
            end
            if serv(2,i)~=0
                IND=[AA{serv(2,i)},IND];
                AA{serv(2,i)}=[]; % clear AA
            end
            IND=[IND,[ii(k) i]];% indexes of candidates in the same cluster M
            AA{M}=unique([AA{M},IND]);% in the cluster M the old plus the new candidates
            serv(2,AA{M})=M;% record M in all the candidates in the cluster M 
            tot2=tot2+length(AA{M});
        end
    else
        if serv(2,i)==0
            serv(2,i)=i;
            AA{i}=i;
        end
    end
    
    
end


[aa,bb,index]=unique(serv(2,:));
index=int32(index);

disp('start part 2')

[ic1,ia,ic]=unique(index);
[ic1,ii]=sort(ic);
ic1d=diff(ic1);
ic1d=ic1d(:);
ic1d=[1; ic1d];
ncl=length(ia);
indii=zeros(2,ncl);
ic2=find(ic1d);
indii(2,:)=[ic2(2:length(ic2))-1 ; length(ic1d)];
indii(1,:)=ic2;

if n2 == 8
    clust0=zeros(18,ncl);
else
    clust0=zeros(19,ncl);
end

iii=0;

for i = 1:ncl
    if i == floor(i/500)*500
        s=datestr(now);
        fprintf('f = %f clust = %d cand = %d  %s \n',A(1,iii),i,iii,s)
    end
    iiii=ii(indii(1,i):indii(2,i));
    liiii=length(iiii);
    cand1=A(:,iiii);
    clust0(1,i)=liiii;
    clust0(2,i)=sum(cand1(5,:));
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
    if n2 == 9
        clust0(19,i)=max(cand1(9,:));
    end
    iii=iii+liiii;
end

clust.clust=clust0;
clust.index=index;
clust.dist=dist;
clust.dfr=dfr;
clust.dsd=dsd;
clust.ftime1=toc(funt);
save pippo
%
% function d=distance(const,arr,dfr,dsd)
%
% d=sqrt(...
%     ((const(1)-arr(1,:))/dfr).^2+...
%     ((const(4)-arr(4,:))/dsd).^2+...
%     ((const(2)-arr(2,:))./(abs(const(7))+abs(arr(7,:)))).^2+...
%     ((const(3)-arr(3,:))./(abs(const(8))+abs(arr(8,:)))).^2 ...
%     );
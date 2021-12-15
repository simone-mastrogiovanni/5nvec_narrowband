function [holes xfr hfr]=cand_holes(list,dfr,dbet,maxhole,verb)
% Finds frequency holes in candidates
%
%     [holes xfr hfr]=cand_holes(list,dfr,dbet)
%
%   list     file list
%   dfr      frequency step (e.g. 0.01)
%   dbet     beta step (e.g. 10)
%   maxhole  max value to consider a hole (def 0)
%   verb     verbosity (def 0)

% Version 2.0 - August 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

histpar=[0 2 1000];
xhist=histpar(1):histpar(2):histpar(3);

if ~exist('maxhole','var')
    maxhole=0;
end

if ~exist('verb','var')
    verb=0;
end
fidlist=fopen(list,'r');
nfiles=0;

N=0;
frmin=10000; frmax=0;
betmin=1000; betmax=-1000;
nbet=round(180/dbet);
bandmax=(1:nbet)*dbet-90;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    fil=fscanf(fidlist,'%s',1)
    if verb > 0
        str=sprintf('  %s ',fil);
        disp(str);
    end
    
    A=load(fil);
%    A=A.A; % non serve nella nuova versione di Matlab (R2013a)
    [n1 n2]=size(A);
    if n1 > 0
        N=N+n1;

        frmin=min(frmin,min(A(:,1)));
        frmax=max(frmax,max(A(:,1)));

        betmin=min(betmin,min(A(:,3)));
        betmax=max(betmax,max(A(:,3)));
    end
end
fclose(fidlist);

fprintf('             %d candidates \n',N)
fprintf(' frequency min,max :  %f %f \n',frmin,frmax)
fprintf(' beta min,max      :  %f %f \n',betmin,betmax)

frmin0=floor(frmin);
frmax0=ceil(frmax);
nfr=round((frmax0-frmin0)/dfr)+1;

xfr=frmin0+(0:nfr-1)*dfr;
hfr=zeros(length(xfr),nbet);

fidlist=fopen(list,'r');
while (feof(fidlist) ~= 1)
    fil=fscanf(fidlist,'%s',1);
    
    A=load(fil);
%    A=A.A;  % non serve nella nuova versione di Matlab (R2013a)
    
    [n1 n2]=size(A);
    if n1 > 0
        h=hist(A(:,1),xfr);
        bet=mean(A(:,3));
        ibet=floor((bet+90)/dbet)+1;%size(hfr),size(h)
        hfr(:,ibet)=hfr(:,ibet)+h';
    end
end
fclose(fidlist);

for i = 1:nbet
    hfr1=hfr(:,i);
    if sum(hfr1) > 0
        ii=find(hfr1 <= maxhole);
        iii=diff(ii);
        iiii=find(iii > 1);
        finh=ii(iiii);
        inih=ii(iiii+1);
        inih=[ii(1); inih(1:length(inih)-1)];
        a=zeros(length(inih),2);
        a(:,1)=inih;
        a(:,2)=finh;
        holes{i}=(a-1)*dfr+frmin0;
    end
end

[h1, h2]=size(holes);

for i = 1:h2
    a=holes{i};
    if ~isempty(a)
        figure,hold on
        plot(xfr,hfr(:,i)),grid on
        tit=sprintf('band %d: %d - %d deg. of lat.',i,bandmax(i)-dbet,bandmax(i));
        title(tit)
        xlabel('Hz')
        ylabel('Histogram of candididates with holes')
        [n1,n2]=size(a);
        y=max(hfr(:,i))/2;
        for j = 1:n1
            plot([a(j,1) a(j,2)],[y y],'r','LineWidth',2)
        end
        for j = 2:n1
            plot([a(j-1,2) a(j,1)],[y y]*0.99,'g','LineWidth',2)
        end
        his=hist(hfr(:,i),xhist);
        figure,loglog(xhist,his),grid on
        title(tit)
        xlabel('n cand')
    end
end

figure,hold on
ymin=1000;
ymax=-1000;
title('Holes')
xlabel('Hz')
ylabel('Beta')

for i = 1:h2
    a=holes{i};
    if ~isempty(a)
        [n1,n2]=size(a);
        y=dbet*i-90-dbet/2;
%         y=y*ones(n1,1);
        for j = 1:n1
            plot([a(j,1) a(j,2)],[y y],'LineWidth',2)
        end
        for j = 2:n1
            plot([a(j-1,2) a(j,1)],[y y]*0.99,'g','LineWidth',2)
        end
        ymin=min(ymin,y);
        ymax=max(ymax,y);
    end
end

h=zeros(h2,20);
x=h;
figure,hold on,grid on
title('Length of holes (Hz)')
xlabel('Hz')
ylabel('Hz')

for i = 1:h2
    a=holes{i};
    if ~isempty(a)
        [n1,n2]=size(a);
        tcol=rotcol(i);
        tcol1=rotcol(i+1);
        plot(a(:,1),a(:,2)-a(:,1),'color',tcol)
        plot(a(:,1),a(:,2)-a(:,1),'.','color',tcol1)
        fprintf('band %d : %d - %d -> holes %f Hz \n',i,bandmax(i)-dbet,bandmax(i),sum(a(:,2)-a(:,1)))
        [h(i,:),x(i,:)]=hist(a(:,2)-a(:,1),20);
    end
end

figure,hold on,grid on
title('Histogram of length of holes (Hz)')
xlabel('Hz')

for i = 1:h2
    tcol=rotcol(i);
    tcol1=rotcol(i+1);
    semilogy(x(i,:),h(i,:),'color',tcol)
    semilogy(x(i,:),h(i,:),'.','color',tcol1)
end
figure,hold on,grid on
title('Coverage of holes of at least a certain length')
xlabel('Hz')
ylabel('Hz')

for i = 1:h2
    tcol=rotcol(i);
    tcol1=rotcol(i+1);
    y=h(i,:).*x(i,:);
    y=cumsum(y(length(y):-1:1));
    y=y(length(y):-1:1);
    semilogy(x(i,:),y,'color',tcol)
    semilogy(x(i,:),y,'.','color',tcol1)
end
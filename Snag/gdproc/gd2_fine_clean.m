function [g2out medi medj med]=gd2_fine_clean(g2in,pcoutup,pcoutlow,twin,yesint)
% gd2_fine_clean  fine cleaning of a gd2
%
%      [g2out up low cut]=gd2_fine_clean(g2in,pcoutup,pcoutlow,twin,yesint)
%
%   g2in       input gd2
%   pcoutup    percentage of upper cut in abs value (typically 0.01)
%   pcoutlow   percentage of lower cut in abs value excluded 0 (typically 0.005)
%   twin       [medwin windt] :
%                  medwin  median moving time window, typically 10 (days)
%                    (0 default)
%                  windt   cut window (for yesint, typically 512/86400 days)
%   yesint     if present, permitted intervals (2,n)
%               can be a cell array with more yesint arrays

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

M=y_gd2(g2in);
x=x_gd2(g2in);
[n m]=size(M);
me=zeros(1,m);
sd=me;
cut=me;

if exist('twin','var')
    if twin(1) > 0
        medwin=twin(1);
        windt=twin(2);
    else
        medwin=10;
        windt=512/86400;
    end
else
    medwin=10;
    windt=512/86400;
end

dx=min(diff(x));
kwin=ceil(medwin/dx);

if exist('yesint','var')
    if iscell(yesint)
        nyes=length(yesint);
        yescell=yesint;
        yesint=yescell{1};
    else
        nyes=1;
    end
    
    t=x_gd2(g2in);
    
    for ii = 1:nyes
        if ii > 1
            yesint=yescell{ii};
        end
        
        [n1 n2]=size(yesint);
        k1=1;
%         ii=0;
        for i = 1:n
            iok=0;
            for j = k1:n2
                if t(i) > yesint(2,j)-windt
                    k1=j;
                    continue
                end
                if t(i) < yesint(1,j)+windt
                    break
                end
                iok=1;
            end
            if iok == 0
                M(i,:)=0;%zeros(1,m);
            end
        end
    end
end

medi=zeros(m,1);

for i = 1:m
    y=M(:,i);
    i1=find(y);
    na=length(i1);
%     if na <= 0
%         fprintf('all zero data %d \n',i)
%         continue
%     end
    medi(i)=median(y(i1));
    
    M(:,i)=y/medi(i);
end

so=M(:);
ia=find(so);
so=so(ia);
na=length(ia);

k1=floor(na*pcoutlow)+1;
k2=floor(na*(1-pcoutup));

low1=so(k1);
up1=so(k2);

for i = 1:m
    y=M(:,i);
    i1=find(y >= low1 & y <= up1);
    y(i1)=0;
end

for j = 1:n
    y=M(j,:);
    j1=find(y);
    medj(j)=median(y(j1));
end

for j = 1:n    
    j1=max(1,i-kwin);
    j2=min(n,i+kwin);
    xx=x(j1:j2);
    yy=medj(j1:j2);
    ii=find(abs(x(i)-xx) < twin);
    med(j)=median(yy(ii));
    
    if med(j) > 0
        M(j,:)=y/med(j);
    end
end

g2out=g2in;
g2out=edit_gd2(g2out,'y',M);

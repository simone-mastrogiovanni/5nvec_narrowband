function [g2out up low cut]=gd2_fine_clean_long(g2in,pcoutup,pcoutlow,twin,yesint)
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

up=0;low=0;cut=0;
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

for i = 1:m
    y=M(:,i);i
    [i1 i2]=find(y);
    na=length(i1);
    if na <= 0
        fprintf('all zero data %d \n',i)
        continue
    end
    med1=zeros(1,na);
     
    ya=y(i1);
    xa=x(i1);

    n=length(i1);
    gout=i1*0;

    for j = 1:na
        j1=max(1,j-kwin);
        j2=min(n,j+kwin);
        xx=xa(j1:j2);
        yy=ya(j1:j2);
        ii=find(abs(xa(j)-xx) < medwin);
        meda(j)=median(yy(ii));
    end
    
    i1=floor(na*pcoutlow)+1;
    i2=floor(na*(1-pcoutup));
    ya=ya./meda';
    ya=sort(ya);
    low1=ya(i1);
    up1=ya(i2);
    absy=abs(y);
    i1=find(absy < low1 | absy > up1);
    y(i1)=0;
    M(:,i)=y;
%     low(i)=low1;
%     up(i)=up1;
%     cut(i)=length(i1)/n;
end

g2out=g2in;
g2out=edit_gd2(g2out,'y',M);

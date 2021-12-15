function [g2out up low cut M2]=gd2_rough_clean(g2in,pcoutup,pcoutlow,yesint,windt)
% gd2_rough_clean  rough cleaning of a gd2
%
%      g2out=gd2_rough_clean(g2in,nsig,yesint)
%
%   g2in       input gd2
%   pcoutup    percentage of upper cut in abs value (typically 0.01)
%   pcoutlow   percentage of lower cut in abs value excluded 0 (typically 0.005)
%   yesint     if present, permitted intervals (2,n)
%               can be a cell array with more yesint arrays
%   windt      cut window (for yesint, typically in days)

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

M=y_gd2(g2in);
[n m]=size(M);
me=zeros(1,m);
sd=me;
cut=me;

if exist('yesint','var')
    if iscell(yesint)
        nyes=length(yesint);
        yescell=yesint
        yesint=yescell{1};
    else
        nyes=1;
    end
    
    t=x_gd2(g2in);
    
    iii=find(t<45000); % check on errors on gps
    if ~isempty(iii)
        if iii(1) > 1
            for i = 2:n
                if t(i) < t(i-1)
                    t(i)=t(i-1);
                    M(i,:)=0;
                end
            end
        else
            disp('Error on time data')
            return
        end
        disp('Some error on time data: data cut')
    end
    
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

M2=M;

for i = 1:m
    M1=M(:,i);
    [i1 i2 M1a]=find(M1);
    na=length(M1a);
    if na <= 0
        fprintf('all zero data %d \n',i)
        continue
    end
    i1=floor(na*pcoutlow)+1;
    i2=floor(na*(1-pcoutup));
    M1a=sort(M1a);
    low1=M1a(i1);
    up1=M1a(i2);
    M1a=abs(M1);
    i1=find(M1a < low1 | M1a > up1);
    M1(i1)=0;
    M(:,i)=M1;
    low(i)=low1;
    up(i)=up1;
    cut(i)=length(i1)/n;
end

g2out=g2in;
g2out=edit_gd2(g2out,'y',M,'x',t);
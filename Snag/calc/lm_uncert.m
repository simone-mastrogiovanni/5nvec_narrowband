function [unc yhist yphist]=lm_uncert(fun,varargin)
% lm_uncert   computes uncertainty for a given function
%
%           [unc yhist yphist]=lm_uncert(fun,varargin)
%
%        fun    function handle (provided by the user, should be computed
%               by array; if not, use lm_uncert_noarr 
%
%    varargin{i}=[val unc typ]
%    
%    typ = 0    gauss (statistical error)
%    typ = 1    uniform (resolution error)
%    typ = 2    exponential
%    typ = 3    user-defined distribution (the user should provide the function usernd)
%    if the last value of varargin is a scalar, that is the number of simulations
%
%    unc.y         value
%    unc.yy        mean value
%    unc.ymedian   median
%    unc.dy        total uncertainty
%    unc.sig1      ± unc, equalized to 1 gaussian sigma in prob (0.15865 and 0.84135)
%    unc.py(k)     partial mean value
%    unc.pdy(k)    partial uncertainties

% Version 2.0 - April 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

N=1000000;
NP=100000;
sigm=0.15865;
sigp=0.84135;
n=length(varargin);
strcom='y=fun(';
str1=strcom;

fid=1;
lvin=length(varargin{n});
if lvin <= 2
    vv=varargin{n};
    N=vv(1);
    NP=round(N/10);
    n=n-1;
    if lvin > 1
        fid=vv(2);
    end
end

r=zeros(n,N);
y=zeros(1,N);

for i = 1:n
    vars{i}=inputname(i+1);
    aa=varargin{i};
    val(i)=aa(1);
    uncer(i)=aa(2);
    typ(i)=aa(3);
    switch typ(i)
        case 0
            r(i,:)=val(i)+randn(1,N)*uncer(i);
        case 1
            r(i,:)=val(i)+(rand(1,N)-0.5)*2*uncer(i);
        case 2
            r(i,:)=val(i)*exprnd(1,1,N);
        case 3
            r(i,:)=val(i)+usernd(N)*uncer(i);
    end
    if i == 1
        strcom=[strcom sprintf('r(%d,:)',i)];
        str1=[str1 sprintf('val(%d)',i)];
    else
        strcom=[strcom sprintf(',r(%d,:)',i)];
        str1=[str1 sprintf(',val(%d)',i)];
    end
end

strcom=[strcom ');'];
str1=[str1 ');'];
kk=strfind(str1,',');
kk0=strfind(str1,');');
kk=[kk kk0];

eval(strcom);

unc.yy=mean(y);
unc.dy=std(y);
[yhist x]=hist(y,200);
dx=x(2)-x(1);
yhist=yhist/(N*dx);
aaa=prctile(y,[sigm 0.5 sigp]*100);
unc.ymedian=aaa(2);
unc.sig1=[aaa(1)-aaa(2) aaa(3)-aaa(2)];
figure,stairs(x,yhist),grid on
figure,stairs(x,yhist,'LineWidth',2,'Color','k'),grid on,hold on
yhist=gd(yhist);
yhist=edit_gd(yhist,'ini',x(1),'dx',dx);

eval(str1);
unc.y=y;

bi=6;
y=zeros(1,NP);

for i = 1:n
    switch typ(i)
        case 0
            r=val(i)+randn(1,NP)*uncer(i);
        case 1
            r=val(i)+(rand(1,NP)-0.5)*2*uncer(i);
        case 2
            r=val(i)*exprnd(1,1,NP);
    end
    str2=[str1(1:bi) 'r' str1(kk(i):length(str1))];
    bi=kk(i);
    eval(str2);
    unc.py(i)=mean(y);
    unc.pdy(i)=std(y);
    yhist1=hist(y,x)/(NP*dx);
    col=rotcol(i);
    stairs(x,yhist1,'color',col),grid on
    yhist1=gd(yhist1);
    yhist1=edit_gd(yhist1,'ini',x(1),'dx',x(2)-x(1));
    yphist{i}=yhist1;
end

set(gca,'YScale','log');
unc.vars=vars;
unc.varsval=val;
unc.varsunc=uncer;
unc.varstyp=typ;

fprintf(fid,'\n')
fprintf(fid,'              Output value: %f \n',unc.y)
fprintf(fid,'                mean value: %f \n',unc.yy)
fprintf(fid,'                    median: %f \n',unc.ymedian)
fprintf(fid,'   symmetrical uncertainty: %f \n',unc.dy)
fprintf(fid,'asymmetrical uncertainties: %f  %f\n',unc.sig1)
if unc.y ~= 0
    fprintf(fid,'      relative uncertainty: %f \n\n',unc.dy/abs(unc.y))
end

fprintf(fid,'      Partial uncertainties \n\n')
fprintf(fid,'  variable    value       type     vunc.        relun     part.unc.    weight\n')

for i = 1:n
    switch typ(i)
        case 1
            str='uniform';
%             un=uncer(i)/sqrt(3);
        otherwise
            str='normal ';
%             un=uncer(i);
    end
    un=uncer(i);
    relun=un/abs(val(i));
    weig=unc.pdy(i)/(relun*unc.y);
    fprintf(fid,'  %7s    %f   %s  %f     %f    %f    %f\n',vars{i},val(i),str,un,relun,unc.pdy(i),weig)
end
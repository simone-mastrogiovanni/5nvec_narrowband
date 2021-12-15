function [unc yhist yphist]=lm_uncert_noarr(fun,varargin)
% lm_uncert   computes uncertainty for a given function
%
%           [unc yhist yphist]=lm_uncert_noarr(fun,varargin)
%
%        fun    function handle (provided by the user)
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

N=100000;
NP=10000;
sigm=0.15865;
sigp=0.84135;
n=length(varargin);
strcom='out=fun(';
str1=strcom;

if length(varargin{n}) == 1
    N=varargin{n};
    NP=round(N/10);
    n=n-1;
end

r=zeros(n,N);
y=zeros(1,N);

for i = 1:n
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
        strcom=[strcom sprintf('x(%d)',i)];
        str1=[str1 sprintf('val(%d)',i)];
    else
        strcom=[strcom sprintf(',x(%d)',i)];
        str1=[str1 sprintf(',val(%d)',i)];
    end
end

strcom=[strcom ');'];
str1=[str1 ');'];
kk=strfind(str1,',');
kk0=strfind(str1,');');
kk=[kk kk0];

for i = 1:N
    x=r(:,i);
    eval(strcom);
    y(i)=out;
end

eval(str1);
unc.y=out;
unc.yy=mean(y);
unc.dy=std(y);
[yhist x]=hist(y,200);
aaa=prctile(y,[sigm 0.5 sigp]*100);
unc.ymedian=aaa(2);
unc.sig1=[aaa(1)-aaa(2) aaa(3)-aaa(2)];
figure,stairs(x,yhist),grid on
figure,stairs(x,yhist/N,'LineWidth',2,'Color','k'),grid on,hold on
yhist=gd(yhist);
yhist=edit_gd(yhist,'ini',x(1),'dx',x(2)-x(1));

bi=8;
y=zeros(1,NP);

for i = 1:n
    switch typ(i)
        case 0
            r=val(i)+randn(1,N)*uncer(i);
        case 1
            r=val(i)+(rand(1,N)-0.5)*2*uncer(i);
        case 2
            r=val(i)*exprnd(1,1,N);
    end
    str2=[str1(1:bi) 'r(j)' str1(kk(i):length(str1))];
    bi=kk(i);
    for j = 1:NP
        eval(str2);
        y(j)=out;
    end
    unc.py(i)=mean(y);
    unc.pdy(i)=std(y);
    yhist1=hist(y,x)/NP;
    col=rotcol(i);
    stairs(x,yhist1,'color',col),grid on
    yhist1=gd(yhist1);
    yhist1=edit_gd(yhist1,'ini',x(1),'dx',x(2)-x(1));
    yphist{i}=yhist1;
end
function [WH,ov,un,H,W,x]=whist(data,w,x,norm)
% weighted histogram: each data increase its bin of a specified amount (weight)
%
%     [WH,ov,un,H,W,x]=whist(data,w,x,norm)
%
%    data
%    w      weights
%    x      center of bins
%    norm   0 or 1 weight normalization (def 1)
%
%    WH     weighted histogram
%    ov     overflow data
%    un     underflow data
%    H      standard histogram
%    W      weight histogram

% Version 2.0 - July 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('norm','var')
    norm=1;
end
if norm > 0
    w=w/mean(w);
end
if length(x) == 1
    n=x;
    xmin=min(data);
    xmax=max(data);
    dx=((xmax-xmin)/n);
    eps=dx*0.000001;
    x=xmin+dx/2-eps:dx+eps/n:xmax;
else
    n=length(x);
end

H=zeros(1,n);
WH=H;
X=zeros(1,n+1);

X(1)=x(1)-(x(2)-x(1))/2;
X(2:n)=(x(1:n-1)+x(2:n))/2;
X(n+1)=x(n)+(x(n)-x(n-1))/2;

for i = 1:n
    ii=find(data >= X(i) & data < X(i+1));
    if ~isempty(ii)
        H(i)=length(ii);
        WH(i)=sum(w(ii));
    end
end

ii=find(data < X(1));
un=length(ii)/mean(w(ii));

ii=find(data > X(n+1));
ov=length(ii)/mean(w(ii));

[W,xW]=hist(w,200);
dx=xW(2)-xW(1);
W=gd(W);
W=edit_gd(W,'ini',xW(1),'dx',dx);
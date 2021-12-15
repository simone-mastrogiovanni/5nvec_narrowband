function aut=sb_autcor(p,n,N,patt)
%SB_AUTCOR autocorrelazione pattern sequenze binarie
%
%  p,n   usuali
%  N     sample size
%  patt  pattern (stati). Se manca, tutti.

r=rand(1,N);
b=zeros(1,N);
ii=find(r>p);
b(ii)=1;

filt=2.^(0:n-1);

x=filter(filt,1,b);

nn=2^n;
M=2*n;
all=0;
if ~exist('patt','var')
    patt=0:nn-1;
    all=1;
end
aut=zeros(length(patt),2*M+1);size(patt),size(aut)

j=0;
for i = patt
    f=zeros(1,N);
    ii=find(x==i);
    f(ii)=1;
    xx=xcov(f,M);
    j=j+1;
    aut(j,:)=xx;
end

aut=aut/N;
figure,plot(-M:M,aut),grid on, hold on,plot(-M:M,aut,'.')

if all == 1
    aut1(:,1:2*n-1)=aut(:,n+2:2*M-n);
    saut=sum(aut1');
    figure,plot(0:nn-1,saut),grid on,hold on,plot(0:nn-1,saut,'r.')
end
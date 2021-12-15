function out=prob_coin_rank(N,n1,n2,ncoin)
% probability for coincidedence ranking
%
%    N      sample dimension
%    n1,n2  number of elements in the two coincidence classes
%    ncoin  coincidences found

p1=(1:n1/N:n1)/n1;
p1(end+1:N)=1;
p2=(1:n2/N:n2)/n2;
p2(end+1:N)=1;
p2=p2(randperm(N));
P=1./(p1.*p2);
    
P=sort(P,'ascend');
p=(N:-1:1)/N;

nh=floor(sqrt(N));

out.p1=p1;
out.p2=p2;
out.P=P;
out.p=p;
[h,xh]=hist(P,1:100*nh);

figure,loglog(xh,h),grid on,hold on,loglog(xh,h,'r.')

figure,loglog(P,p),grid on,hold on,loglog(P,p,'r.')

nsettest=floor(N/ncoin)-1;
i1=1;
P=P(1:end-ncoin);
P=P(randperm(N-ncoin));

for i = 1:nsettest
   P1=P(i1:i1+ncoin-1);
   i1=i1+ncoin;
    meanc(i)=mean(P1);
    maxc(i)=max(P1);
end

out.meanc=meanc;
out.maxc=maxc;

[h,x]=hist(out.meanc,1000);
figure,loglog(x,h/nsettest),grid on,hold on,loglog(x,h/nsettest,'r.'),title('mean for ncoin')
ch=cumsum(h/nsettest,'reverse');
figure,loglog(x,ch),grid on,hold on,loglog(x,ch,'r.'),title('mean for ncoin')

[h,x]=hist(out.maxc,10000);
figure,loglog(x,h/nsettest),grid on,hold on,loglog(x,h/nsettest,'r.'),title('max for ncoin')
ch=cumsum(h/nsettest,'reverse');
figure,loglog(x,ch),grid on,hold on,loglog(x,ch,'r.'),title('max for ncoin')
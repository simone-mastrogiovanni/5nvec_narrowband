function [aa aa1 bb]=abrac(p,n,M)
%
%  p   prob di a  (es: 1/2)
%  n   lunghezza sequenze  (es: 4)
%  M   numero prove (es: 2000)

nn=2^n;
aa=zeros(nn,M);
aa1=aa;
aa2=aa;
aaa=0;
filt=2.^(0:n-1);
len=zeros(1,M);
MM=5*round(1/(p^n*(1-p)^n));
if MM < 1500
    MM=1500;
end

for i = 1:M
    r=rand(1,MM);
    
    [i1 i2]=find(r<p);
    r=r*0;

    r(i2)=1;

    fab=filter(filt,1,r);
    fab=fab(n+1:length(fab));
    
    for ii = 1:nn
        [i1 i2]=find(fab==ii-1);
        aa(ii,i)=i2(1);
        aa1(ii,i)=i2(2)-i2(1);
%         aa2(ii,i)=i2(3)-i2(2);
    end
    
    [i1 i2]=find(fab==nn-1);
    aaa=aaa+i2(1);
end

aaa=aaa/M

for ii = 1:nn
    bb(ii)=mean(aa(ii,:));
    bb1(ii)=mean(aa1(ii,:));
%     bb2(ii)=mean(aa2(ii,:));
    str=dec2base(ii-1,2);
    cc(ii)=sum(sign(sscanf(str,'%1d')));
end

pp=p.^cc.*(1-p).^(n-cc);
figure,plot(0:nn-1,1./pp),hold on,plot(0:nn-1,bb,'r'),plot(0:nn-1,bb,'r.')
plot(0:nn-1,bb1,'g'),plot(0:nn-1,1./pp,'.'),grid on

% figure,plot(0:nn-1,(bb-1./pp).*pp),hold on,grid on,plot(0:nn-1,(bb-1./pp).*pp,'.r');
for i = 1:nn
    str=dec2bin(i-1,n);
    c=sscanf(str,'%1d');%1./p.^c
    r=sum(1./p.^c)-n+1;
    fprintf(' %3d %s %f %f %f %f\n',i,str,bb(i),1./pp(i),bb(i)-1./pp(i),r);
end
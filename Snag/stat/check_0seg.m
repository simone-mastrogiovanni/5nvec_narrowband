function [on off]=check_0seg(gin)
% check_0seg(gin)  checks statistics of 0 segments in a gd

y=y_gd(gin);
i=find(y);
y(i)=1;

y=diff(y);
i=find(y);
i1=(y(i(1))+1)/2;
on=zeros(1,floor(length(i)/2));

for j = 1:2:length(i)-2
    jj=floor((j+1)/2);
    on(jj)=i(j+1)-i(j);
    off(jj)=i(j+2)-i(j+1);
end

x=(0:100)*500;
h1=hist(on,x);
h2=hist(off,x);
figure,semilogy(x,h1),grid on
hold on,semilogy(x,h2,'r'),grid on,title('blue on, red off')
fprintf('Mean on = %f ; mean off = %f \n',mean(on),mean(off))
fprintf(' Max on = %f ;  max off = %f \n',max(on),max(off))
fprintf(' Min on = %f ;  min off = %f \n',min(on),min(off))
function ch=ev_corr(evch,dt,mode)
%EV_CORR  event correlation
%
%    evch    event-channel input structure
%     dt     dead-time (s)
%    mode    =1 simmetric, 0 time arrow
%
%    evcho   event-channel ouput structure

ch=evch.ch;
nchtot=length(evch.ch.an);
ddt=dt/86400;

t1(1:nchtot)=-2000*ddt;
n1(1:nchtot)=0;
corr=zeros(nchtot,nchtot);
bg=corr;

if mode == 1
	for i = 1:evch.n
        k1=evch.ev(i).ch;
        n1(k1)=n1(k1)+1;
        t1(k1)=evch.ev(i).t;
        for j=1:k1-1
            if abs(t1(k1)-t1(j)) <= ddt
                corr(j,k1)=corr(j,k1)+1;
                corr(k1,j)=corr(j,k1);
            end
            if abs(t1(k1)-t1(j)) <= 1000*ddt
                bg(j,k1)=bg(j,k1)+1;
                bg(k1,j)=bg(j,k1);
            end
        end
	end
else
	for i = 1:evch.n
        k1=evch.ev(i).ch;
        n1(k1)=n1(k1)+1;
        t1(k1)=evch.ev(i).t;
        for j=1:nchtot
            if (t1(k1)-t1(j)) <= ddt
                corr(j,k1)=corr(j,k1)+1;
            end
        end
        for j=1:nchtot
            if (t1(k1)-t1(j)) <= 1000*ddt
                bg(j,k1)=bg(j,k1)+1;
            end
        end
	end
end

bg=(bg-corr)/999;

for i = 1:nchtot
    for j = 1:nchtot
        ii=1;
        if i == j
            ii=0;
        end
        cov(i,j)=(corr(i,j)-bg(i,j))*ii/sqrt(n1(i)*n1(j));
    end
end

ch.corr=corr;
ch.bg=bg;
ch.cov=cov;onlypos(cov)
matimag(log10(onlypos(cov)))
colorbar
function nc=coincid(N1,N2,dx1,dx2,win)

x1=rand(1,N1);
x1=sort(x1);
x2=rand(1,N2);
x1=sort(x1);

w=(dx1+dx2)*win/2;

m1=1;
nc=0;

for ii = 1:N1
    for jj = m1:N2
        aa=x1(ii)-x2(jj);
        if aa > w
            m1=jj;
            continue
        end
        if aa < -w
            break
        end
        nc=nc+1;
    end
end
            

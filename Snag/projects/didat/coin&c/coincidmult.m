function ncm=coincidmult(M,N1,N2,dx1,dx2,win)
% COINCIDMULTI
%
%  M      number of 

set_random
nc(1:M)=0;
w=(dx1+dx2)*win/2;

for kk = 1:M
    x1=rand(N1,1);
    x1=sort(x1);
    x2=rand(N2,1);
    x2=sort(x2);
    m1=1;
    %figure,plot(x1),hold on,plot(x2,'r')

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
            nc(kk)=nc(kk)+1;
        end
    end
end     

ncm=mean(nc)
std(nc)
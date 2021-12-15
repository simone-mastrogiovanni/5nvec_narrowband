function B=mean_every(A,dim,n)
%MEAN_EVERY  computes the mean every n samples of dimension dim (1,2)
%
%        B=mean_every(A,dim,n)
%
%    A      input array
%    dim    dimension 1 or 2 (0 takes :)
%    n      number of samples

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if dim == 0
    A=A(:);
    dim=1;
end
siz=size(A);
n=round(n);
dim=round(dim);

if dim == 1
    nout=ceil(siz(1)/n);
    B=zeros(nout,siz(2));
    for j = 1:siz(2)
        for i = 1:nout
            i1=(i-1)*n+1;
            i2=i*n;
            i2=min(i2,siz(1));
            B(i,j)=mean(A(i1:i2,j));
        end
    end
else
    nout=ceil(siz(2)/n);
    B=zeros(siz(1),nout);
    for j = 1:siz(1)
        for i = 1:nout
            i1=(i-1)*n+1;
            i2=i*n;
            i2=min(i2,siz(2));
            B(j,i)=mean(A(j,i1:i2));
        end
    end
end
    
function g=redcoe_spec(gin,ibands)
% reduced coherence spectra
%
%    g=redcoe_spec(gin,ibands)
%
%   gin     input spectrum gd (standard bilateral)
%   ibands  integration bands (in unit of df)
%           if it is a single value, the output is a gd, otherwise is a gd2
%           if dim=2, computes logatithmically ibands(2) bands up to ibands(1)

% Version 2.0 - September 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

Nsubbands=200;
bb=zeros(Nsubbands,2);
y=y_gd(gin);
x=x_gd(gin);
n=n_gd(gin);
ini=ini_gd(gin);
df=dx_gd(gin);
n=floor(n/2)*2;
y=y(1:n);

nn=floor(n/Nsubbands);
i1=0;
for i = 1:nn:n-nn
    i1=i1+1;
    bb(i1,1)=i;
    bb(i1,2)=mean(y(i:i+nn-1));
end
thr=mean(y)/10;
mm=find(bb(:,2) > thr);
mm1=bb(mm(1),1);
mm2=bb(mm(length(mm)),1);

dt=1/(n*df);
M=length(ibands);
if M == 2
    base=ibands(1).^(1/ibands(2));
    M=ibands(2);
    ibands=base.^(1:M);
end

A=zeros(n,M);
acor=ifft(y);

for j = 1:M
    iband=round(ibands(j));
    win=acor*0;
    win(1:iband)=(iband:-1:1)/iband;
    win(n-iband+2:n)=(1:iband-1)/iband;
    win=win*n/iband;
    win=ifft(win);%size(acor),size(win)
    A(:,j)=real(fft(acor.*win));
end

for j = 1:M
    iband=round(ibands(j));
    mu=mean(A(mm1:mm2,j));
    A(mm1:mm2,j)=(A(mm1:mm2,j)-mu)*sqrt(iband)+mu;
end

if M == 1
    g=gd(A);
    g=edit_gd(g,'ini',ini,'dx',df);
    
    figure,plot(g)
else
    g=gd2(A');
    g=edit_gd2(g,'x',ibands,'ini2',ini,'dx2',df);
    
    g1=edit_gd2(g,'x',1:M);
    gd2_points(g1)
    figure,plot(x,A),grid on
end


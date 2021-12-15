function A=sb_creamatabs(n,p,stats,nostats)
% crea matrice con stati assorbenti o nulli

nn=2^n;
nn2=nn/2;
ns=length(stats);
if exist('nostats','var')
    nns=length(nostats);
else
    nns=0;
end

A=zeros(nn,nn);
for i = 1:nn2
    A(i,2*i-1)=1-p;
    A(i,2*i)=p;
    A(i+nn2,2*i-1)=1-p;
    A(i+nn2,2*i)=p;
end

for k = 1:nns
    n0=nostats(k)+1;

    if nostats(k) < nn2
        A(n0,n0*2)=0;
        A(n0,n0*2-1)=0;
    else
        n00=n0-nn2;
        A(n0,n00*2)=0;
        A(n0,n00*2-1)=0;
    end
end

for k = 1:ns
    n0=stats(k)+1;

    if stats(k) < nn2
        A(n0,n0*2)=0;
        A(n0,n0*2-1)=0;
    else
        n00=n0-nn2;
        A(n0,n00*2)=0;
        A(n0,n00*2-1)=0;
    end
    A(n0,n0)=1;
end

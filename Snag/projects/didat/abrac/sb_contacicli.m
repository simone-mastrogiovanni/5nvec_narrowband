function nc=sb_contacicli(n)

nc=0;

if 2^(2*n) > 10^8
    disp('matrice troppo grande')
    return
end

A=sb_creamat(n,0.5);
nct=zeros(1,n);
zz=nct;

for i = 1:n
    ii=find(diag(A^i));
    zz(ii)=1;
    ii=find(zz);
    nct(i)=length(ii);
end

nc(2:n)=diff(nct);
nc(1)=nct(1);
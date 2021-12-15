% apply_all_mf

fr0=0.38198710;
[wB5 fr]=compute_5comp(gwB,fr0);
wB5=wB5(:);

aL0=compute_5comp(pL0wien,fr0);
aL45=compute_5comp(pL45wien,fr0);

aCC=compute_5comp(pCCwien,fr0);
aCA=compute_5comp(pCAwien,fr0);

neps=50;
npsi=90;

[sigl sigr asigl asigr]=crea_all_5sour(aL0,aL45,neps,npsi);
mfl=asigl*0;
mfr=mfl;

for i = 1:neps
    eps(i)=(i-1)/(neps-1);
    for j = 1:npsi
        psi(j)=90*(j-1)/npsi;
        mfsigl=conj(sigl(i,j,:))./sum(abs(sigl(i,j,:)).^2);
        mfsigr=conj(sigr(i,j,:))./sum(abs(sigr(i,j,:)).^2);
        mfsigl=mfsigl(:);
        mfsigr=mfsigr(:);
        mfl(i,j)=abs(sum(mfsigl.*wB5)).^2;
        mfr(i,j)=abs(sum(mfsigr.*wB5)).^2;
    end
end

figure,image(psi,eps,mfl,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon')
figure,image(psi,eps,mfr,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon')
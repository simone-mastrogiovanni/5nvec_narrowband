% apply_all_mfC_false

fr0=0.38194046;
[wC5 fr]=compute_5comp(gwC,fr0);
wC5=wC5(:);

aL0=compute_5comp(pL0wien,fr0);
aL45=compute_5comp(pL45wien,fr0);
aCA=compute_5comp(pCAwien,fr0);
wC5=aL0+aCA;
wC5=wC5(:);

% aCC=compute_5comp(pCCwien,fr0);
% aCA=compute_5comp(pCAwien,fr0);

neps=50;
npsi=90;

[sigl sigr asigl asigr]=crea_all_5sour(aL0,aL45,neps,npsi);
mfl=asigl*0;
mfr=mfl;
cohel=mfl;
coher=mfl;

for i = 1:neps
    eps(i)=(i-1)/(neps-1);
    for j = 1:npsi
        psi(j)=90*(j-1)/npsi;
        mfsigl=conj(sigl(i,j,:))./sum(abs(sigl(i,j,:)).^2);
        mfsigr=conj(sigr(i,j,:))./sum(abs(sigr(i,j,:)).^2);
        mfsigl=mfsigl(:);
        mfsigr=mfsigr(:);
        outmfl=sum(mfsigl.*wC5);
        outmfr=sum(mfsigr.*wC5);
        mfl(i,j)=abs(outmfl).^2;
        mfr(i,j)=abs(outmfr).^2;
        for k = 1:5
            cohel(i,j)=cohel(i,j)+abs(outmfl.*sigl(i,j,k)).^2;
            coher(i,j)=coher(i,j)+abs(outmfr.*sigr(i,j,k)).^2;
        end
        cohel(i,j)=cohel(i,j)./sum(abs(wC5).^2);
        coher(i,j)=coher(i,j)./sum(abs(wC5).^2);
    end
end

figure,image(psi,eps,mfl,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon'),title('Matched filter response - CCW')
figure,image(psi,eps,mfr,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon'),title('Matched filter response - CW')

figure,image(psi,eps,cohel,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon'),title('Coherence - CCW')
figure,image(psi,eps,coher,'CDataMapping','scaled'),colorbar
xlabel('psi'),ylabel('epsilon'),title('Coherence - CW')

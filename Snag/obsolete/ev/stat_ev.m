function chstr=stat_ev(evch)
%STAT_EV  statistics for events

nchtot=length(evch.ch.an);
nch=evch.ch.nch;

chstr=evch.ch;
nev=zeros(1,nchtot);
minea=nev+10^34;
maxea=nev-10^34;
minecr=nev+10^34;
maxecr=nev-10^34;
minel=nev+10^34;
maxel=nev-10^34;
lh=30;
hista=zeros(nchtot,lh);
histcr=hista;
histl=hista;

for i = 1:evch.n
    for j = 1:nchtot
        if evch.ev(i).ch == j;
            nev(j)=nev(j)+1;
            minea(j)=min(minea(j),evch.ev(i).a);
            maxea(j)=max(maxea(j),evch.ev(i).a);
            minecr(j)=min(minecr(j),evch.ev(i).cr);
            maxecr(j)=max(maxecr(j),evch.ev(i).cr);
            minel(j)=min(minel(j),evch.ev(i).l);
            maxel(j)=max(maxel(j),evch.ev(i).l);
        end
    end
end

for j = 1:nchtot
    maxea(j)=(maxea(j)-minea(j))*1.000001;
    if maxea(j) <= 0
        maxea(j)=1;
    end
    maxea(j)=30/maxea(j);
    maxecr(j)=(maxecr(j)-minecr(j))*1.000001;
    if maxecr(j) <= 0
        maxecr(j)=1;
    end
    maxecr(j)=30/maxecr(j);
    maxel(j)=(maxel(j)-minel(j))*1.000001;
    if maxel(j) <= 0
        maxel(j)=1;
    end
    maxel(j)=30/maxel(j);
end

for i = 1:evch.n
    j=evch.ev(i).ch;
    k=floor((evch.ev(i).a-minea(j))*maxea(j))+1;
    hista(j,k)=hista(j,k)+1;
    k=floor((evch.ev(i).cr-minecr(j))*maxecr(j))+1;
    histcr(j,k)=histcr(j,k)+1;
    k=floor((evch.ev(i).l-minel(j))*maxel(j))+1;
    histl(j,k)=histl(j,k)+1;
end

chstr.nev=nev;
chstr.minha=minea;
chstr.dha=maxea;
chstr.hista=hista;
chstr.minhcr=minecr;
chstr.dhcr=maxecr;
chstr.histcr=histcr;
chstr.minhl=minel;
chstr.dhl=maxel;
chstr.histl=histl;

figure,stairs(hista')
figure,stairs(histcr')
figure,stairs(histl')


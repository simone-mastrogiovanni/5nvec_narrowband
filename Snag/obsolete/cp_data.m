function cand=cp_data

file=selfile('');
fid=fopen(file,'r');
head=psc_rheader(fid)

[cand0,nread]=fread(fid,10000000,'uint16');

nread

frr=(cand0(1:nread-1)+65536*cand0(2:nread))*.000001;

ii=find(frr>450&frr<460);

nn=length(ii)

%cand=ii;

 [i1,i2,iii]=find(ii(1:nn-1)==(ii(2:nn)-8));
 nnn=length(iii)
 
 cand=zeros(7,nnn);
% figure,plot(diff(ii),'.')
% cand(1,:)=frr(iii);
iii=0;
for i = 1:nn-1
    if ii(i) == ii(i+1)-8
        iii=iii+1;
        cand(1,iii)=frr(ii(i));
        cand(2,iii)=cand0(ii(i)+2)*head.dlam;
        cand(3,iii)=cand0(ii(i)+3)*head.dbet-90;
        cand(4,iii)=cand0(ii(i)+4)*head.dsd1;
        cand(5,iii)=cand0(ii(i)+5)*head.dcr;
        cand(6,iii)=cand0(ii(i)+6)*head.dmh;
        cand(7,iii)=cand0(ii(i)+7)*head.dh;
    end
end

iii

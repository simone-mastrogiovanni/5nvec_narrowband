function mcand=psc_vec2mat(vcand,head,nn)
%PSC_VEC2MAT  converts a candidate vector 8*n to a candidate matrix (7,n)
%
%  head  candidate header structure
%  nn    how many

mcand=zeros(7,length(vcand)/8);
mcand(1,:)=psc_readfr(vcand);
vcand=reshape(vcand,8,nn);

mcand(2,:)=vcand(3,:)*head.dlam;
mcand(3,:)=vcand(4,:)*head.dbet-90;
mcand(4,:)=vcand(5,:)*head.dsd1;
mcand(5,:)=vcand(6,:)*head.dcr;
mcand(6,:)=vcand(7,:)*head.dmh;
mcand(7,:)=vcand(8,:)*head.dh;

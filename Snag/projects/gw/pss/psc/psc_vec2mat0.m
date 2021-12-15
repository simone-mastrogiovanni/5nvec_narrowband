function mcand=psc_vec2mat0(vcand)
%PSC_VEC2MAT0  converts a candidate vector 8*n to a binary candidate matrix (7,n)

mcand=zeros(8,length(vcand)/8);
mcand(1,:)=floor(psc_readfr(vcand)*1000000);
vcand=reshape(vcand,8,nn);

mcand(2,:)=vcand(3,:);
mcand(3,:)=vcand(4,:);
mcand(4,:)=vcand(5,:);
mcand(5,:)=vcand(6,:);
mcand(6,:)=vcand(7,:);
mcand(7,:)=vcand(8,:);

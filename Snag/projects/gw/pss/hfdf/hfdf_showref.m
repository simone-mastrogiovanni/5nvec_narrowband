function out=hfdf_showref(job_pack_0)
%
%  job_pack_0    job_pack_0 structure
  
% Version 2.0 - December 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

out=struct();

sky=job_pack_0.sky;
ref=job_pack_0.basic_info.mode.ref;
sd=job_pack_0.basic_info.run.sd;

kk=ref.skylayers; % number of layers
kkk=2*kk+1;
kkkk=kkk^2;
patches=sky.x;
[n1,n2]=size(patches);
refpat=zeros(2,n1*kkkk);
jj=0;

for j = 1:n1
    patch=patches(j,:);
    dlam=(patch(3)/kkk)*(-kk:kk);
    dbet1=(patch(4)-patch(2))/kkk;
    dbet2=(patch(5)-patch(2))/kkk;
    dbet=[dbet1*(kk:-1:1) 0 dbet2*(1:kk)];
    
    for i = -kk:kk
        i1=i+kk+1;
        for j = -kk:kk
            j1=j+kk+1;
            jj=jj+1;
            refpat(1,jj)=patch(1)+dlam(i1);
            refpat(2,jj)=patch(2)+dbet(j1);
        end
    end
end

figure,plot(refpat(1,:),refpat(2,:),'.'),hold on,grid on
plot(patches(:,1),patches(:,2),'rO','MarkerFaceColor','r')
title('Sky patches')

dsd0=sd.dnat;
dsd=dsd0/ref.sd.enh;
sdmin=sd.min+dsd*ref.sd.min;
nsd=-ref.sd.min+ref.sd.max+1;
rawsd=sd.min:dsd0:sd.max*1.00001;
nrawsd=length(rawsd);
refsd=sdmin:dsd:sd.max+dsd*ref.sd.max;
nrefsd=length(refsd);
figure,plot(refsd/dsd0,refsd,'.'),hold on,grid on
title('Spin-down'),ylabel('spin-down'),xlabel('normalized spin-down')
plot(rawsd/dsd0,rawsd,'rO','MarkerFaceColor','r')
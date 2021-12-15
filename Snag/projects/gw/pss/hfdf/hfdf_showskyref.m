function out=hfdf_showskyref(tfft,freq,nlayers)
%
%  runstr    run structure (VSR2(1), VSR4,...)
  
% Version 2.0 - January 2014 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

out=struct();

ndop=round(1.06e-4*freq*tfft);
[x,b,index,nlon]=pss_optmap(ndop,1);

kk=nlayers;

kkk=2*kk+1;
kkkk=kkk^2;
patches=x;
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

out.patches=patches;
out.refpat=refpat;
out.ndop=ndop;
out.tfft=tfft;
out.freq=freq;
out.nlayers=nlayers;

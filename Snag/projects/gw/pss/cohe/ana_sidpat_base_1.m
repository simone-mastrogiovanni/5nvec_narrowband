function [sidpat_base,eta,psi]=ana_sidpat_base(ant,direc,res)
% analyze sidereal pattern
%
%   ant     antenna (e.g. 'virgo')
%   direc   direction structure or cw-source structure
%   res     resolution for eta and psi [neta,npsi] (def [101,89])

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('res','var')
    res=[101,89];
end

sour=direc;
culm=1;
n=100;

deta=2/(res(1)-1);
dpsi=90/res(2);
eta=-1:deta:1;
psi=0:dpsi:90-dpsi;

s0=zeros(res(1),res(2));
s1=s0;
s2=s0;
s3=s0;
s4=s0;
sabs=s0;
i=0;

for e = eta
    i=i+1;
    sour.eta=e;
    j=0;
    for p = psi
        j=j+1;
        sour.psi=p;
        [sidpat,ftsp,v]=pss_sidpat(sour,ant,n,culm);
        s0(i,j)=ftsp(1);
        s1(i,j)=ftsp(2);
        s2(i,j)=ftsp(3);
        s3(i,j)=ftsp(4);
        s4(i,j)=ftsp(5);
        sabs(i,j)=sqrt(s1(i,j)^2+s2(i,j)^2+s3(i,j)^2+s4(i,j)^2);
    end
end

sidpat_base.s0=s0;
sidpat_base.s1=s1;
sidpat_base.s2=s2;
sidpat_base.s3=s3;
sidpat_base.s4=s4;
sidpat_base.sabs=sabs;
sidpat_base.s1n=s1./abs(s1);
sidpat_base.s2n=s2./abs(s2);
sidpat_base.s3n=s3./abs(s3);
sidpat_base.s4n=s4./abs(s4);

sidpat_base.min0=min(s0(:));
sidpat_base.max0=max(s0(:));
sidpat_base.ave0=mean(s0(:));
sidpat_base.sd0=std(s0(:));
sidpat_base.min1=min(s1(:));
sidpat_base.max1=max(s1(:));
sidpat_base.ave1=mean(s1(:));
sidpat_base.sd1=std(s1(:));
sidpat_base.min2=min(s2(:));
sidpat_base.max2=max(s2(:));
sidpat_base.ave2=mean(s2(:));
sidpat_base.sd2=std(s2(:));
sidpat_base.min3=min(s3(:));
sidpat_base.max3=max(s3(:));
sidpat_base.ave3=mean(s3(:));
sidpat_base.sd3=std(s3(:));
sidpat_base.min4=min(s4(:));
sidpat_base.max4=max(s4(:));
sidpat_base.ave4=mean(s4(:));
sidpat_base.sd4=std(s4(:));
sidpat_base.minsabs=min(sabs(:));
sidpat_base.maxsabs=max(sabs(:));
sidpat_base.avesabs=mean(sabs(:));
sidpat_base.sdsabs=std(sabs(:)); 
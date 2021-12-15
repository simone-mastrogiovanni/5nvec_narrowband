function out=ana_sidpat(sidpat,sidpat_base)
% analyze sidereal pattern
%
%   sidpat       sidereal pattern (array) or Fourier components abs val (0 1 2 3 4)
%   sidpat_base  sidpat_base, created by ana_sidpat_base

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

sidpat=sidpat(:)';
if ~exist('sidpat_base','var')
    sidpat_base=[201,90];
end

if length(sidpat) > 5 
    ftsp=fft(sidpat);
    ftsp=conj(ftsp(1:5));
else
    ftsp=sidpat;
end

[ne,np]=size(sidpat_base.s0);
spb_fit=zeros(ne,np);

eta0=sidpat_base.eta(1);

s0=sidpat_base.s0;
s1=sidpat_base.s1;
s2=sidpat_base.s2;
s3=sidpat_base.s3;
s4=sidpat_base.s4;

s1n=sidpat_base.s1n;
s2n=sidpat_base.s2n;
s3n=sidpat_base.s3n;
s4n=sidpat_base.s4n;

spb_fitn=zeros(ne,np);

for i = 1:ne
    for j = 1:np
        sidpatn=[1,s1n(i,j),s2n(i,j),s3n(i,j),s4n(i,j)]; % size(ftsp(2:5)),size(sidpatn(2:5))
        spb_fitn(i,j)=real(ftsp(2:5)*sidpatn(2:5).');
    end
end

mea=mean(spb_fitn(:));
sd=std(spb_fitn(:));

spb_fitn=gd2(spb_fitn);
deta=sidpat_base.eta(2)-sidpat_base.eta(1);
dpsi=sidpat_base.psi(2)-sidpat_base.psi(1);
spb_fitn=edit_gd2(spb_fitn,'ini',eta0,'dx',deta,'ini2',0,'dx2',dpsi);
out.spb_fit=spb_fitn;
plot(spb_fitn),xlabel('eta'),ylabel('psi')
[cr1,cr2,cr0]=gd2_crest(spb_fitn,'rx','bo');
out.cr1=cr1;
out.cr2=cr2;
out.cr0=cr0;

fprintf('   spb_fitn\n')  
[x,y,z,ix,iy]=twod_peaks(spb_fitn,mea,12,10,1);
out.eta0=x;
out.psi0=y;
out.amp0=z;

smodel=[s0(ix(1),iy(1)),s1(ix(1),iy(1)),s2(ix(1),iy(1)),s3(ix(1),iy(1)),s4(ix(1),iy(1))];
out.smodel=smodel;
amp1=sum(abs(sidpat(2:5)))/sum(abs(smodel(2:5)));
sig0=amp1*smodel(1);
out.amp1=amp1;
out.sig0=sig0;
out.snr2=sig0/(sidpat(1)-sig0);
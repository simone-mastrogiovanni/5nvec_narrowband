function [spa spm sph spt]=bb_spec_mean(str,SMint,minp,maxp,ic,nbb,bbHz)
% cent_spec_mean  evaluation of the h-density from data in the "big bands"
%                 created by calc_cent and similar
%
%     [spa spm sph spt]=bb_spec_mean(str,minp,maxp,ic,ncent,bbHz)
%
%    str     name string (exept the numeral suffix)
%    SMint   science mode intervals
%    minp    lower threshold (0 - 1)
%    maxp    higher threshold (0 - 1)
%    ic      = 2 done on the square (def 0)
%    nbb     number of big bands (def 20)
%    bbHz    bb bandwidth (def 100)
%
%    spa     averaged spectrum
%    spm     median spectrum
%    sph     harmonic mean spectrum
%    spt     total average (only SM cut)

WINDT=512/86400;

if ~exist('ic','var')
    ic=0;
end

if ~exist('nbb','var')
    nbb=20;
end

if ~exist('bbHz','var')
    bbHz=100;
end

str1=str

str2=sprintf(',%f,%f,SMint,WINDT);',maxp,minp);
    
for i = 1:nbb
    str=str1;
    strfil=sprintf('%s%02d',str,i);str
    fprintf('File %s band %d - %d Hz\n',strfil,(i-1)*bbHz,i*bbHz)
    eval(['load ' strfil])
    eval(['[g2out up low cut M2]=gd2_rough_clean(' strfil str2])
    
    M=y_gd2(g2out);
    [n1t n2f]=size(M);
    
    if i == 1
        dfr=dx2_gd2(g2out);
        spa=zeros(1,(nbb-1)*n2f+1);
        spm=spa;
        sph=spa;
        spt=spa;
    end
    
    i1=(i-1)*(n2f-1)+1;
    i2=i1+n2f;
    
    for j = 1:n2f
        m=M(:,j);
        ii=find(m);
        m=m(ii);
        m2=M2(:,j);
        ii=find(m2);
        m2=m2(ii);
        if ic == 2
            m=m.^2;
            m2=m2.^2;
        end
        spt(i1+j-1)=mean(m2);
        spa(i1+j-1)=mean(m);
        spm(i1+j-1)=median(m);
        sph(i1+j-1)=length(m)/sum(1./m);
    end
    
    if ic == 2
        spt=sqrt(spt);
        spa=sqrt(spa);
        spm=sqrt(spm);
        sph=sqrt(sph);
    end
    
    eval(['clear ' strfil])
end

spt=gd(spt);
spt=edit_gd(spt,'dx',dfr);
spa=gd(spa);
spa=edit_gd(spa,'dx',dfr);
spm=gd(spm);
spm=edit_gd(spm,'dx',dfr);
sph=gd(sph);
sph=edit_gd(sph,'dx',dfr);

figure,semilogy(spt,'k'),hold on,semilogy(spa,'b'),semilogy(spm,'r'),semilogy(sph,'g'),grid on
title(['Mean h density evaluation for ' str1]),xlabel('Hz') 
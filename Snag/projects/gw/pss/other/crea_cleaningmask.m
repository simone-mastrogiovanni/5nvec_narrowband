function mask=crea_cleaningmask(peakfr,nofr,nomfr,yesfr,thrblob)
% CREA_CLEANINGMASK  creates a cleaning mask for peakmaps on the basis of
%                    the peakfr histogram
%
%     crea_cleaningmask(peakfr,nofr,nomfr,yesfr,thrblob,thratt)
%
%     peakfr    peakfr gd
%     nofr      excluded frequencies; mat[nfr,4] with (centr. freq, band, att.band, thr.att.)
%                0 -> no, <0 -> only attention band
%     nomfr     excluded frequencies and harmonics; mat[nfr,4] with (centr. freq, band, att.band, thr.att.). 0 -> no
%     yesfr     not excluded frequencies; mat[nfr,2] with (centr. freq, band). 0 -> no
%     thrblob   threshold on unexpected blobs (def = 1.2)

% Version 2.0 - March 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('thrblob','var')
    thrblob=1.2;
end

if ~exist('thratt','var')
    thratt=1.6;
end

pf=y_gd(peakfr);
mm=mean(pf);
n=length(pf);
df=dx_gd(peakfr);
x=x_gd(peakfr);

figure
plot(x,pf/mm),grid on,hold on

mask=pf*0;
pf1=mask;

if length(nofr) > 1 
    mask=exclude_freq(mask,pf/mm,nofr,df,thratt);
end
if length(nomfr) > 1 
    mask=exclude_mfreq(mask,pf/mm,nomfr,df,thratt);
end

pf=pf.*(1-mask)/mean(pf);

for i =2:n
    imin=floor(i-i*0.0001);
    imax=ceil(i+i*0.0001);
    if imax > n
        imax=n;
    end
    
%     pf1(i)=sum(pf(imin:imax))/(imax-imin+1);
    sspf=sum(sign(pf(imin:imax)));
    if sspf > 0
        pf1(i)=sum(pf(imin:imax))/sspf;
    else
        pf1(i)=1;
    end
    if pf1(i) > thrblob
        mask(i)=1;
    end
end

if length(yesfr) > 1 
    mask=include_freq(mask,yesfr,df);
end

plot(x,pf,'g')
plot(x,pf1,'r')
figure
plot(x,pf.*(1-mask)),grid on,hold on
plot(x,mask,'r.')
sss=sum(mask);
disp(sprintf(' Number of cancelled bins: %d/%d ; ratio %f',sss,n,sss/n));



function mask=exclude_freq(mask,pf,nofr,df,thratt)
% excludes single frequencies and limits attention band

ifrmin=round((nofr(:,1)-nofr(:,2))/df)-1;
ifrmax=round((nofr(:,1)+nofr(:,2))/df)+1;
[i1,i2]=size(nofr)

for i = 1:i1
    if nofr(:,2) >= 0
        mask(ifrmin(i):ifrmax(i))=1;
    end
end

kfrmin=round((nofr(:,1)-nofr(:,3))/df)-1;
kfrmax=round((nofr(:,1)+nofr(:,3))/df)+1;
pf=pf/mean(pf);

for i = 1:i1
    thratt1=thratt;
    if nofr(i,4) > 0 
        thratt1=nofr(i,4);
    end
    for j = kfrmin(i):kfrmax(i)
        if pf(j) > thratt1
            mask(j)=1;
        end
    end
end



function mask=exclude_mfreq(mask,pf,nomfr,df,thratt)
% excludes frequencies and harmonics and limits attention bands

[i1,i2]=size(nomfr);
n=length(mask);
pf=pf/mean(pf);

for i = 1:i1
    nharm=floor(n*df/nomfr(i,1));
    for j = 1:nharm
        ifrmin=round((nomfr(i,1)*j-nomfr(i,2))/df)-1;
        ifrmax=round((nomfr(i,1)*j+nomfr(i,2))/df)+1;
        if ifrmax > n
            ifrmax=n;
        end
        mask(ifrmin:ifrmax)=1;
        
        kfrmin=round((nomfr(i,1)*j-nomfr(i,3))/df)-1;
        kfrmax=round((nomfr(i,1)*j+nomfr(i,3))/df)+1;
        if kfrmax > n
            kfrmax=n;
        end
        thratt1=thratt;
        if nomfr(i,4) > 0 
            thratt1=nomfr(i,4);
        end
        for k = kfrmin:kfrmax
            if pf(k) > thratt1
                mask(k)=1;
            end
        end
    end
end



function mask=include_freq(mask,yesfr,df)
% includes single frequencies

ifrmin=round((yesfr(:,1)-yesfr(:,2))/df)-1;
ifrmax=round((yesfr(:,1)+yesfr(:,2))/df)+1;
[i1,i2]=size(yesfr);

for i = 1:i1
    mask(ifrmin(i):ifrmax(i))=0;
end
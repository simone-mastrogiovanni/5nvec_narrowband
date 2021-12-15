function [A sp stot spar]=multi_5vect(gin,DT,fr0,ant)
% MULTI_5VECT  creates many 5-vect one for each DT interval
%
%     [A sp]=multi_5vect(gin,DT,fr0)
%
%   gin    input gd
%   DT     time interval (days - starts at 0 hour)
%   fr0    frequency
%
%   A      5-vects  (n,5)
%   sp     spects   (n,:)
%   stot   total spectrum
%   spar   .fr frequency errors of the five lines (5,:)
%          .apeak (square)amplitude of the five lines (5,:)
%          .fb (square) out-band  (:)

% Version 2.0 - June 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ST=86164.09053083288;

y=y_gd(gin);
dt=dx_gd(gin);
ini=ini_gd(gin);
n=n_gd(gin);
cont=cont_gd(gin);
fr=cont.appf0;
t0=cont.t0;
t00=t0-floor(t0);
tt=t0;
cont1=cont;
if ~exist('fr0','var')
    fr0=fr-floor(fr*dt)/dt;
end

I0=round(t00*86400/dt)-1;
N0=round(DT*86400/dt);
N2=N0-I0;
N1=1;
i=0;
df=1/(DT*86400*4);
kf1=round((fr0-6/ST)/df);
kf2=round((fr0+6/ST)/df); % fr0,df,kf1,kf2
dkf=round((1/ST)/df);
f1=kf1*df-df;

while N2 < n
    if i > 0 && (N2-N1) < N0/4
        break
    end
    yy=y(N1:N2);
    tt=tt+(N2-N1+1)*dt;
    N1=N2+1;
    N2=N2+N0;
    if N2 > n
        N2=n;
    end
    i=i+1;
    gg=gd(yy);
    gg=edit_gd(gg,'ini',ini,'dx',dt,'cont',cont1);
    cont1.t0=tt;
    [B fr fact0corr]=compute_5comp_sid0(gg,fr0,ant);
    A(i,:)=B;
    yy(length(yy)+1:N0)=0;
    gg=edit_gd(gg,'y',yy);
    s=gd_pows(gg,'resolution',4,'window',2);%dx_gd(s)
    ss=y_gd(s); % length(yy),length(ss),kf1,kf2
    sp(:,i)=ss(kf1:kf2);
    fb(i)=(mean(ss(kf1:kf1+dkf))+mean(ss(kf2:-1:kf2-dkf)))/2;
end

npeaks=10; % disp('??????'),i
peakfr=zeros(npeaks,i+1);
peaka=peakfr;

clear y
s=gd_pows(gin,'resolution',4,'window',2);
dft=dx_gd(s);
kft1=round((fr0-6/ST)/dft);
kft2=round((fr0+6/ST)/dft);
dkft=round((1/ST)/dft);
stot=s(kft1:kft2);
fb(i+1)=(mean(s(kft1:kft1+dkft))+mean(s(kft2:-1:kft2-dkft)))/2;
figure,semilogy(stot),grid on,hold on
thresh=max(stot)/100;
[pfr,pa]=oned_peaks(stot,thresh,npeaks,4);
% peakfr=zeros(length(pfr),i+1);
% peaka=peakfr;
peakfr(1:length(pfr),i+1)=pfr;
peaka(1:length(pfr),i+1)=pa;

masp=max(max(sp));
masp=max(masp,max(s));
misp=min(min(sp));
ft(1)=fr0-2/ST;
ft(2)=fr0-1/ST;
ft(3)=fr0;
ft(4)=fr0+1/ST;
ft(5)=fr0+2/ST;
plot([fr0-2/ST fr0-2/ST],[misp masp],'m:')
plot([fr0-1/ST fr0-1/ST],[misp masp],'m:')
plot([fr0 fr0],[misp masp],'m:')
plot([fr0+1/ST fr0+1/ST],[misp masp],'m:')
plot([fr0+2/ST fr0+2/ST],[misp masp],'m:')

x=f1+(0:kf2-kf1)*df;
fs=zeros(5,i);

for j = 1:i
    tcol=rotcol(j);
    semilogy(x',sp(:,j),'color',tcol)
    thresh=max(sp(:,j))/100;
    [pfr pa]=oned_peaks(sp(:,j),thresh,npeaks,4);
    peakfr(1:length(pfr),j)=pfr;
    peaka(1:length(pfr),j)=pa;
    peakfr(1:length(pfr),j)=f1+df*(peakfr(1:length(pfr),j)-1);
    for k = 1:5
        [aa ii]=min(abs(peakfr(1:length(pfr),j)-ft(k)));
        fs(k,j)=peakfr(ii,j)-ft(k);
        as(k,j)=pa(ii);
    end
end

for k = 1:5
    [aa ii]=min(abs(peakfr(1:length(pfr),i+1)-ft(k))); 
    fs(k,i+1)=peakfr(ii,i+1)-ft(k);
    as(k,i+1)=peaka(ii,i+1);
end

A(i+1,:)=zeros(1,5);
figure
for j = 1:i
    [tcol colstr colchar]=rotcol(j);
    show_5vect(A(j,:),1,colchar)
%     A(i+1,:)=A(i+1,:)+A(j,:);
end

 A(i+1,:)=compute_5comp_sid0(gin,fr0,ant);

[tcol colstr colchar]=rotcol(i+1);
show_5vect(A(i+1,:),1,colchar)

spar.fr=fs;
spar.apeak=as;
spar.fb=fb;
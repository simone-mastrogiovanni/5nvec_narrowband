function out=coin_mat(cand1,cand2,dfr,dsd,reduce)
%
%     out=coin_mat(cand1,cand2,dfr,dsd,reduce)
%
%  criteria used:
%                1 closeness
%                2 amplitude
%                3 both
%          top and weighted
%
%  output are
%           out.Csour
%           out.Asour
%           out.CAsour
%           out.CsourM
%           out.AsourM
%           out.CAsourM

% Version 2.0 - July 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n1 dum]=size(cand1);
[n2 dum]=size(cand2);
close=zeros(n1,n2);
amp=close;
fr=close;
lam=close;
bet=close;
sd=close;
h=close;
a1=cand1(:,5)-min(cand1(:,5));
a2=cand2(:,5)-min(cand2(:,5));
a1=a1/max(a1);
a2=a2/max(a2);

for ii = 1:n1
    close(ii,:)=distance(cand1(ii,:),cand2,dfr,dsd,reduce);
    amp(ii,:)=a1(ii)+a2;
    fr(ii,:)=(cand1(ii,1)+cand2(:,1))/2;
    lam(ii,:)=(cand1(ii,2)+cand2(:,2))/2;
    bet(ii,:)=(abs(cand1(ii,3))+abs(cand2(:,3)))*sign(cand1(ii,3))/2;
    sd(ii,:)=(cand1(ii,4)+cand2(:,4))/2;
    h(ii,:)=(cand1(ii,9)+cand2(:,9))/2;
end

close=close(:);
amp=amp(:);
ampclose=amp.*close;
fr=fr(:);
lam=lam(:);
bet=bet(:);
sd=sd(:);
h=h(:);

[dum,I1]=min(close);
[dum,I2]=max(amp);
[dum,I3]=min(amp./close);

out.Csour=[fr(I1),lam(I1),bet(I1),sd(I1),h(I1)];
out.Asour=[fr(I2),lam(I2),bet(I2),sd(I2),h(I2)];
out.CAsour=[fr(I3),lam(I3),bet(I3),sd(I3),h(I3)];

close=1./close;
close=close/mean(close);
amp=amp/mean(amp);
ampclose=ampclose/mean(ampclose);
out.CsourM=[mean(fr.*close) mean(lam.*close) mean(abs(bet).*close) mean(sd.*close) mean(h.*close)];
out.AsourM=[mean(fr.*amp) mean(lam.*amp) mean(abs(bet.*amp)) mean(sd.*amp) mean(h.*amp)];
out.CAsourM=[mean(fr.*ampclose) mean(lam.*ampclose) mean(abs(bet).*ampclose) mean(sd.*ampclose) mean(h.*ampclose)];


function d=distance(const,arr,dfr,dsd,reduce)

d=min(sqrt(...
    ((const(1)-arr(:,1))/dfr).^2+...
    ((const(4)-arr(:,4))/dsd).^2+...
    ((const(2)-arr(:,2))./((const(7)+arr(:,7))/reduce(2))).^2+...
    ((const(3)-arr(:,3))./((const(8)+arr(:,8))/reduce(3))).^2 ...
    ));

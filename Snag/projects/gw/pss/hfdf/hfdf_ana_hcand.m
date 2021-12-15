function [out,fgrid,hgrid]=hfdf_ana_hcand(cand,fgrid,hgrid)
% analysis of h distribution of candidates
%
%      out=hfdf_ana_hcand(cand,band,hgrid)
%
%   cand    refined candidate structure
%   fgrid   frequency grid or step step for the analysis
%   hgrid   h-grid (should be uniform) or resolution

info=cand.info;
[n1,N]=size(cand.cand);
if N == 9
    cand=cand.cand';
    N=n1;
else
    cand=cand.cand;
end

if length(hgrid) == 1
    hgrid=0:hgrid:max(cand(9,:));
end

if length(fgrid) == 1
    dfr=fgrid;
    fgrid=floor(cand(1,1))+dfr/2:dfr:floor(cand(1,N));
else
    dfr=fgrid(2)-fgrid(1);
end
nfgrid=length(fgrid);
nhgrid=length(hgrid);
h=zeros(nfgrid,nhgrid);
mu=zeros(1,nfgrid);
sd=mu;
sk=mu;
ku=mu;

ii=round(interp1(cand(1,:)+(1:N)*0.0001/N,1:N,fgrid-dfr/2));
ii(1)=1;
ii(nfgrid+1)=N;

for i = 1:nfgrid
    if ii(i+1) > ii(i)
        hamp=cand(9,ii(i):ii(i+1));
        h(i,:)=hist(hamp,hgrid);
        mu(i)=mean(hamp);
        sd(i)=std(hamp);
        sk(i)=skewness(hamp);
        ku(i)=kurtosis(hamp);
    end
end

h=gd2(h);
h=edit_gd2(h,'dx',dfr,'ini',fgrid(1),'dx2',hgrid(2)-hgrid(1));
out.h=h;
plot(h),xlabel('Hz'),ylabel('h'),title('h-amplitude histogram')

mu=gd(mu);
mu=edit_gd(mu,'dx',dfr,'ini',fgrid(1));
out.mu=mu;
figure
plot(mu);xlabel('Hz'),ylabel('h'),title('h-amplitude mean')
hold on,plot(mu,'r.')

sd=gd(sd);
sd=edit_gd(sd,'dx',dfr,'ini',fgrid(1));
out.sd=sd;
figure
plot(sd);xlabel('Hz'),ylabel('h'),title('h-amplitude standard deviation')
hold on,plot(sd,'r.')

sk=gd(sk);
sk=edit_gd(sk,'dx',dfr,'ini',fgrid(1));
out.sk=sk;
figure
plot(sk,'g')
hold on,plot(sk,'r.')

ku=gd(ku);
ku=edit_gd(ku,'dx',dfr,'ini',fgrid(1));
out.ku=ku;
plot(ku);xlabel('Hz'),title('h-amplitude skewness (g) and kurtosis')
hold on,plot(ku,'r.')

hold off
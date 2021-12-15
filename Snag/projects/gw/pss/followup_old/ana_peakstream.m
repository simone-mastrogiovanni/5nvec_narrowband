function out=ana_peakstream(peaks,nbin,capt)
% analysis of a peak stream, as created by peak_correction
%
%  nbin   number of bins in the phase diagram (def 12)

if ~exist('capt','var')
    capt='';
end
if ~exist('nbin','var')
    nbin=12;
end
tim=peaks(1,:);
w=peaks(6,:);
[sid,sol]=sidsolasid(peaks(1,:));
N=length(tim);
hsid=zeros(1,nbin);
hsidw=hsid;
hsol=hsid;
hsolw=hsid;
isid=floor(sid*nbin/24)+1;
isol=floor(sol*nbin/24)+1;
xh=(0.5:nbin)*24/nbin;

for i = 1:nbin
    ii=find(isid == i);
    hsid(i)=length(ii);
    hsidw(i)=sum(w(ii));
    ii=find(isol == i);
    hsol(i)=length(ii);
    hsolw(i)=sum(w(ii));
end

figure,stairs(xh,hsid),hold on,stairs(xh,hsidw,'r'),grid on
title([capt 'Sidereal periodicity']),xlim([0 24]),xlabel('Sidereal hours')
figure,stairs(xh,hsol),hold on,stairs(xh,hsolw,'r'),grid on
title([capt 'Solar periodicity']),xlim([0 24]),xlabel('Solar hours')
sp=ev_spec(peaks(1,:),0,0,0.1,10,10,0,0);
spw=ev_spec(peaks(1,:),0,0,0.1,10,10,peaks(6,:),0);
figure,plot(sp),hold on,plot(spw,'r'),
title([capt 'Event spectrum (red -> Wiener weighted)']),xlabel('days^{-1}')

out.xh=xh;
out.hsid=hsid;
out.hsidw=hsidw;
out.hsol=hsol;
out.hsolw=hsolw;
out.sp=sp;
out.spw=spw;
function out_pr=prob_noncohe(sid,snr,n)
% mc on sidereal pattern
%
%  sid   sidereal pattern (obtained, e.g. as pow by bsd_sid)
%  snr   linear signal-to-noise ratio
%  n     mc dimension

% Snag Version 2.0 - February 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

nsid=length(sid);
ff0=fft(sid);
nf=length(ff0);
nf2=floor(nf/2);

out_pr.snr=snr;
out_pr.sid=sid;
out_pr.maxsid=max(sid);
out_pr.n=n;
out_pr.nsid=nsid;
out.ff0=ff0(1:21);

dera=zeros(n,1);
dera1=zeros(n,1);
sidmax=zeros(n,1);
ff1=zeros(n,21);

for i = 1:n
    ii=randperm(nsid);
    sid1=sid(ii);
    sid1=sid1+snr*sid;
    ff=fft(sid1);
    ff1(i,:)=ff(1:21);
    dera(i)=sum(abs(ff(2:5)).^2/sum(abs(ff(6:21)).^2))*(16/4);
    dera1(i)=sum(abs(ff(2:5)).^2/sum(abs(ff(6:nf2)).^2))*((nf2-5)/4);
end

out_pr.ff1=ff1;
out_pr.dera=dera;
out_pr.dera1=dera1;

% tit=sprintf('eff  (%f)',snr);
% figure,stairs(xeff,heff),grid on,title(tit)
% % figure,semilogy(xeff,out_pr.peff,'r'),grid on,title('peff')
% tit=sprintf('loss  (%f)',snr);
% figure,stairs(xloss,hloss),grid on,title(tit)
% tit=sprintf('ploss  (%f)',snr);
% figure,loglog(xloss,out_pr.ploss,'r'),grid on,title(tit)
% tit=sprintf('A  (%f)',snr);
% figure,stairs(xA,hA),grid on,title(tit)
% tit=sprintf('eff1  (%f)',snr);
% figure,stairs(xeff1,heff1),grid on,title(tit)
% % figure,semilogy(xeff1,out_pr.peff1,'r'),grid on,title('peff1')
% tit=sprintf('loss1  (%f)',snr);
% figure,stairs(xloss1,hloss1),grid on,title(tit)
% tit=sprintf('ploss1  (%f)',snr);
% figure,loglog(xloss1,out_pr.ploss1,'r'),grid on,title(tit)
% tit=sprintf('dist  (%f)',snr);
% figure,stairs(xdist,hdist),grid on,title(tit)
% tit=sprintf('pdist  (%f)',snr);
% figure,loglog(xdist,out_pr.pdist,'r'),grid on,title(tit)

% 
% function xs=xlimits(y,N)
% 
% mi0=min(y);
% ma0=max(y);
% if mi0 < 0.1 & ma0 > 0.2
%     mi=0;
% else
%     mi=mi0;
% end
% if mi0 < 0.8 & ma0 > 0.9
%     ma=1;
% else
%     ma=ma0;
% end
% 
% xs=(((1:N)-0.5)/N)*(ma-mi)+mi;
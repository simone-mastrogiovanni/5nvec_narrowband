% sim_pss_cand_coin

set_random

t1=0;d1=1;s1=1;
t2=0;d2=1;s2=0;

s0=sqrt((s1^2+s2^2)/2)

N=1000000;
amin=0.01;amax=10;

gw=0;
gw=amin*(amax/amin).^rand(N,1); max(gw)
disp(sprintf(' mean gw = %f',mean(gw)))

hx=-2:0.1:(4+(s1^2+s2^2)*max(gw)/2);
nhis=length(hx); disp(nhis)

hgw=hist(gw*s0^2,hx);
HGW=cumsum(hgw(nhis:-1:1))/N;
HGW=HGW(nhis:-1:1);
figure,semilogy(hx,hgw/N),grid on,title('source density')
figure,loglog(hx,hgw/N),grid on,title('source density')
figure,semilogy(hx,HGW),grid on,title('source probability')

q1=randn(N,1)+s1^2*gw;
q2=randn(N,1)+s2^2*gw;
q=min(q1,q2);
hq=hist(q,hx);
HQ=cumsum(hq(nhis:-1:1))/N;
HQ=HQ(nhis:-1:1);

figure,semilogy(hx,HQ),grid on,hold on,title('detection probabilities (f.a.,norm,mix)')

q1=randn(N,1)+s0^2*gw;
q2=randn(N,1)+s0^2*gw;
q=min(q1,q2);
hq=hist(q,hx);
HQ0=cumsum(hq(nhis:-1:1))/N;
HQ0=HQ0(nhis:-1:1);

semilogy(hx,HQ0,'r'),grid on

q1=randn(N,1);
q2=randn(N,1);
q=min(q1,q2);
hq=hist(q,hx);
HQfa=cumsum(hq(nhis:-1:1))/N;
HQfa=HQfa(nhis:-1:1);

semilogy(hx,HQfa,'g-'),grid on

figure,semilogy(hx,HQ-HQfa),grid on,hold on,title('detection probabilities - f.a.prob.')
semilogy(hx,HQ0-HQfa,'r')

figure,plot(hx,(HQ-HQfa)./HGW),grid on,hold on
plot(hx,(HQ0-HQfa)./HGW,'r')

figure,plot(hx,HQ0./HQ),grid on,title('two methods ratio')
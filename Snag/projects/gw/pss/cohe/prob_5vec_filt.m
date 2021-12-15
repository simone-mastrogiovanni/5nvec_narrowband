function out_pr=prob_5vec_filt(ant,sour,snr,n)
% mc on a 5-vect
%
%  ant   antenna
%  sour  source
%  snr   linear signal-to-noise ratio
%  n     mc dimension

% Snag Version 2.0 - January 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[L0 L45 CL CR v Hp Hc]=sour_ant_2_5vec(sour,ant,1);

vA=norm(v);
V=v/vA;

A0=L0/norm(L0)^2;
A45=L0/norm(L45)^2;
B0=L0/norm(L0);
B45=L0/norm(L45);

out_pr.snr=snr;
out_pr.v=v;
out_pr.n=n;

comp=cell(n,1);
eff=zeros(n,1);
loss=zeros(n,1);
A=zeros(n,1);
eff1=zeros(n,1);
loss1=zeros(n,1);
dist1=zeros(n,1);

for i = 1:n
    vn=(randn(1,5)+1j*randn(1,5))/sqrt(10);
    X=V*snr+vn;
    co=compare_5vec(V,X,0);
%     comp{i}=co;
    eff(i)=co.eff;
    loss(i)=co.loss;
    A(i)=co.A;
    Fi0(i)=co.Fi0;
    eff1(i)=co.eff1;
    loss1(i)=co.loss1;
    dist(i)=co.dist;
    ha0(i)=X*A0';
    ha45(i)=X*A45';
    ha(i)=sqrt(abs(X*A45')^2+abs(X*A0')^2);
    hb0(i)=X*B0';
    hb45(i)=X*B45';
    hb(i)=sqrt(abs(X*B45')^2+abs(X*B0')^2);
end

N=round(sqrt(10*n));
% x=((1:N)-0.5)/N;

xeff=xlimits01(eff,N);
heff=hist(eff,xeff);
xloss=xlimits01(loss,N);
hloss=hist(loss,xloss);
xA=xlimits01(A,N);
hA=hist(A,xA);
xeff1=xlimits01(eff1,N);
heff1=hist(eff1,xeff1);
xloss1=xlimits01(loss1,N);
hloss1=hist(loss1,xloss1);
xdist=xlimits01(dist,N);
hdist=hist(dist,xdist);

xha=xlimits(ha,N);
hha=hist(ha,xha);
xhb=xlimits(hb,N);
hhb=hist(hb,xhb);

out_pr.mueff=mean(eff);
out_pr.stdeff=std(eff);
fprintf('\n  eff (mu,std): %f, %f  (snr = %f)\n',out_pr.mueff,out_pr.stdeff,snr)
out_pr.muloss=mean(loss);
out_pr.stdloss=std(loss);
fprintf(' loss (mu,std): %f, %f  (snr = %f)\n',out_pr.muloss,out_pr.stdloss,snr)
out_pr.muA=mean(A);
out_pr.stdA=std(A);
fprintf('    A (mu,std): %f, %f  (snr = %f)\n',out_pr.muA,out_pr.stdA,snr)
out_pr.mueff1=mean(eff1);
out_pr.stdeff1=std(eff1);
fprintf(' eff1 (mu,std): %f, %f  (snr = %f)\n',out_pr.mueff1,out_pr.stdeff1,snr)
out_pr.muloss1=mean(loss1);
out_pr.stdloss1=std(loss1);
fprintf('loss1 (mu,std): %f, %f  (snr = %f)\n',out_pr.muloss1,out_pr.stdloss1,snr)
out_pr.mudist=mean(dist);
out_pr.stddist=std(dist);
fprintf(' dist (mu,std): %f, %f  (snr = %f)\n',out_pr.mudist,out_pr.stddist,snr)

out_pr.muha=mean(ha);
out_pr.stdha=std(ha);
fprintf(' ha (mu,std): %f, %f  (snr = %f)\n',out_pr.muha,out_pr.stdha,snr)

out_pr.xeff=xeff;
out_pr.heff=heff;
out_pr.peff=cumsum(heff,'reverse')/n;
out_pr.xloss=xloss;
out_pr.hloss=hloss;
out_pr.ploss=cumsum(hloss)/n;
out_pr.xA=xA;
out_pr.hA=hA;
out_pr.xeff1=xeff1;
out_pr.heff1=heff1;
out_pr.peff1=cumsum(heff1,'reverse')/n;
out_pr.xloss1=xloss1;
out_pr.hloss1=hloss1;
out_pr.ploss1=cumsum(hloss1)/n;
out_pr.xdist=xdist;
out_pr.hdist=hdist;
out_pr.pdist=cumsum(hdist)/n;
out_pr.xha=xha;
out_pr.hha=hha;
out_pr.pha=cumsum(hha,'reverse')/n;

tit=sprintf('eff  (%f)',snr);
figure,stairs(xeff,heff),grid on,title(tit)
% figure,semilogy(xeff,out_pr.peff,'r'),grid on,title('peff')
tit=sprintf('loss  (%f)',snr);
figure,stairs(xloss,hloss),grid on,title(tit)
tit=sprintf('ploss  (%f)',snr);
figure,loglog(xloss,out_pr.ploss,'r'),grid on,title(tit)
tit=sprintf('A  (%f)',snr);
figure,stairs(xA,hA),grid on,title(tit)
tit=sprintf('eff1  (%f)',snr);
figure,stairs(xeff1,heff1),grid on,title(tit)
% figure,semilogy(xeff1,out_pr.peff1,'r'),grid on,title('peff1')
tit=sprintf('loss1  (%f)',snr);
figure,stairs(xloss1,hloss1),grid on,title(tit)
tit=sprintf('ploss1  (%f)',snr);
figure,loglog(xloss1,out_pr.ploss1,'r'),grid on,title(tit)
tit=sprintf('dist  (%f)',snr);
figure,stairs(xdist,hdist),grid on,title(tit)
tit=sprintf('pdist  (%f)',snr);
figure,loglog(xdist,out_pr.pdist,'r'),grid on,title(tit)

tit=sprintf('ha  (%f)',snr);
figure,stairs(xha,hha),grid on,title(tit)
tit=sprintf('pha  (%f)',snr);
figure,loglog(xha,out_pr.pha,'r'),grid on,title(tit)


function xs=xlimits01(y,N)

mi0=min(y);
ma0=max(y);
if mi0 < 0.1 & ma0 > 0.2
    mi=0;
else
    mi=mi0;
end
if mi0 < 0.8 & ma0 > 0.9
    ma=1;
else
    ma=ma0;
end

xs=(((1:N)-0.5)/N)*(ma-mi)+mi;


function xs=xlimits(y,N)

mi0=min(y);
ma=max(y);
if mi0 < 0.1 & ma > 0.2
    mi=0;
else
    mi=mi0;
end

xs=(((1:N)-0.5)/N)*(ma-mi)+mi;
function r=rank_dist_lexmod(phdist,mu,nmu)
% r=rank_dist_lexmod(phdist,mu) rank distribution of lexical models
%
%  phdist   phoneme distribution
%  mu       mean length of a word
%  nmu      max length of considered words in mus

% Version 2.0 - November 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

q=1/mu;
n=length(phdist);
phdist=sort(abs(phdist),'descend');
phdist=phdist/sum(phdist);
phdist=phdist*(1-q);

if ~exist('nmu','var')
    nmu=3;
end

lenmax=round(mu*nmu);

N=min(round(n^(mu*nmu)),1000000);

r=zeros(1,N);
x=r;

r(1:n)=phdist;
ii=n;
ii1=1;
ii2=n;
N1=n;
fprintf('length %d  words %d  total %d \n',1,n,n);

for k = 2:lenmax
    jj1=1;
    n1=ii2-ii1+1;
    for k1 = 1:n
        x(jj1:jj1+n1-1)=r(ii1:ii2).*phdist(k1);
        jj1=jj1+n1;
    end
    jj=find(x>0.1/N);
    nn=length(jj);
    ii1=ii2+1;
    ii2=ii2+nn;
    r(ii1:ii2)=x(jj);
    N1=N1+nn;
    if ii2 >= N
        break
    end
    fprintf('length %d  words %d  total %d \n',k,nn,N1);
end

fprintf('length %d  words %d  total %d \n',k,nn,N1);

r=sort(r,'descend');

sum(r)
r=r/sum(r);
sum((1:length(r)).*r)

figure,loglog(r),grid on,xlabel('rango'),title('Probabilità delle parole') 
k=(1:lenmax*2);
rteor=cumsum(n.^(k-1))+n.^k/2;
p=(1-q)/n;
pteor=p.^(k-1)*q/n;
hold on,loglog(rteor,pteor,'r*');
figure,plot(cumsum(pteor.*n.^k)),grid on

figure,semilogx(r.*(1:length(r))),grid on,xlabel('rango'),title('Probabilità x Rango')
hold on, semilogx(rteor,pteor.*rteor,'r*')
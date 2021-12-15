function out=mc_filter(MCF,in,ic)
% 5-vect montecarlo filtering
%
%   MCF    mc filter bank [5,N]
%   in     input 5-vects [5,n]
%   ic     plot level

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

N=MCF.N;
mcf=MCF.mcf;
[~,n]=size(in);

dist=zeros(1,n);
I=dist;
eta=I;
psi=I;
dotm=I;
eff=I;
loss=I;

% ain=sqrt(sum(abs(in).^2));
if ic > 0
    figure,hold on
end

for j = 1:n
    in1=in(:,j);
    in1=in1/sqrt(sum(abs(in1).^2));
    rep=repmat(in1,1,N);
    dots=abs(dot(mcf,rep));
    dists=sqrt(1-dots.^2);
    [dist(j),I(j)]=min(dists);
    dotm(j)=dots(I(j));
    eta(j)=MCF.ksour(2,I(j));
    psi(j)=MCF.ksour(3,I(j));
    if ic > 0
        [h,x]=hist(dists,100);
        stairs(x,h),grid on
    end
%     size(in1),size(rep)
    rat=mcf./rep;
    eff1=abs(sum(rat))./sum(abs(rat));
    eff(j)=max(eff1);
%     if ic > 0
%         [h,x]=hist(1-eff1,100);
%     end
end

out.dotm=dotm;
out.dist=dist;
out.I=I;
out.eta=eta;
out.psi=psi;
out.eff=eff;
out.loss=1-eff;
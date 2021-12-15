function [sp,distr]=cerca_nore(t,pers,ris,nore)
%CERCA_NORE  cerca eccessi in n ore successive
%
%    sp       spectrum
%    distr    spectrum distribution
%
%    t        events (sorted)
%    pers[2]  min,max period to be considered
%    nore     numero ore successive

% Version 2.0 - May 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

n=length(t);
frini=1/pers(2);
frfin=1/pers(1);
tobs=t(n)-t(1);
df=1/(ris*tobs);
nf=ceil((frfin-frini)/df);

fr=frini;
sp=zeros(nf,1);
x=sp;

for i = 1: nf
    per=1/fr;
	t1=mod(t,per)*24/per;
    hi=hist(t1,24);
    snore=0;
    
    for k = 1:24
        ii(1)=k;
        for j = 2:nore
            ii(j)=k+j-1;
            if ii(j) > 24
                ii(j)=ii(j)-24;
            end
        end
        snore=max(snore,sum(hi(ii)));
    end
    
    sp(i)=snore;
    x(i)=fr;
    fr=fr+df;
end

figure,plot(x,sp);grid on

mi=min(sp);
ma=max(sp);
x=(0:100)*(ma-mi)/100+mi;
hi=hist(sp,x);
hi=fliplr(hi(:)');
distr=cumsum(hi)/nf;
distr=fliplr(distr(:)');

figure, semilogy(x,distr);grid on, zoom on
disp(sprintf('   mean, dev.st. = %f , %f',mean(sp),std(sp)))



    

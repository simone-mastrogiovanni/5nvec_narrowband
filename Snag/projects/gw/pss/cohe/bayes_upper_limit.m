function [ul apost ulf]=bayes_upper_limit(hx,sx,obst,detst,aprio)
% bayes_upper_limit  bayesian upper-limit
%
%   [ul apost ulf]=bayes_upper_limit(hx,sx,obst,detst,aprio)
%
%   hx       h (signal) distributions abscissas [dx xmax]
%   sx       s (statistic) distributions abscissas [dx xmax]
%   obst     observation of detection statistics (in SNR)
%   detst    density of detection statistics (matrix or number of dof for chi-square) 
%   aprio    a priori distribution (uniform if absent)
%
%   ul       upper limit(s)
%   apost    a posteriori distribution(s)
%   ulf      frequentist upper limit(s)

% Version 2.0 - September 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

conf=0.95;
hx=0:hx(1):hx(2);
sx=0:sx(1):sx(2);
nh=length(hx);
ns=length(sx);
nul=length(obst);
[n1 n2]=size(detst);
ndof=0;
if n1*n2 == 1
    ndof=detst;
end
apost=zeros(nul,nh);
valcf=apost;
ul=zeros(nul,1);
ulf=ul;
if ~exist('aprio','var')
    aprio=ones(1,nh);
end

if ndof > 0
    for i = 1:nh
        s=ncx2pdf(ndof*sx,ndof,hx(i)*ndof)*aprio(i);%figure,plot(sx,s)
        apost(:,i)=spline(sx,s,obst);
        s1=ncx2cdf(ndof*sx,ndof,hx(i)*ndof);
        valcf(:,i)=spline(sx,s1,obst); % cumulative for given h at the observable
    end
    
    for j = 1:nul
        apost(j,:)=apost(j,:)/sum(apost(j,:)*hx(2)); % sum(apost(j,:))*hx(2)
        cu=cumsum(apost(j,:))*hx(2); %figure,plot(cu)
        ii=find(cu >= conf);
        ul(j)=(ii(1)-1)*hx(2);
        jj=find(valcf(j,:) >= (1-conf));
        if ~isempty(jj)
            ulf(j)=(max(jj)-1)*hx(2);
        end
    end
    
    figure,plot(hx,apost),grid on,title('Aposterior density/ies'),xlabel('h');
    figure,semilogy(hx,apost),grid on,title('Aposterior density/ies'),xlabel('h');
    figure,plot(hx,valcf),grid on,title('Detection probablities/ies'),xlabel('h');
    
    if nul > 1
        figure,plot(obst,ul,'*'),grid on,title('Upper limit (bayesian blue, frequentist red)'),xlabel('observation');
        hold on,plot(obst,ulf,'r*')
        figure,plot(sqrt(obst),sqrt(ul),'*'),grid on,title('Upper limit (sqrt)'),xlabel('sqrt(observation)');
        hold on,plot(sqrt(obst),sqrt(ulf),'r*')
    end
else
    disp('not yet implemented')
end
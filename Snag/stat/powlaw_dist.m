function pdf=powlaw_dist(x,pow,par,typ,norm)
% POWLAW_DIST  power law distribution
%              the power is that of Prob(X>x)
%
%      pdf=powlaw_dist(x,pow,par,typ,norm)
%
%    x      x values
%    pow    power (positive)
%    par    range parameter
%    typ    type ('pareto','parlin','parconst','parr1','parr2')
%    norm   forces normalization (suggested for almost full x range)

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('norm','var')
    norm=0;
end
pow1=pow+1;
x=x(:);
switch typ
    case 'pareto'
        ii0=find(x<par);
        ii1=find(x>=par);
        pdf(ii0)=0;
        pdf(ii1)=(pow/par.^-pow)*x(ii1).^(-pow1);
    case 'parlin'
        ii0=find(x<par);
        ii1=find(x>=par);
        pdf(ii1)=x(ii1).^(-pow1);
        pdf(ii0)=x(ii0)*pdf(ii1(1))/x(ii1(1));
        pdf(ii0)=x(ii0)*par.^(-pow1)/par; %sum(pdf)
        aint=par.^(-pow)/pow+par*par.^-pow1/2
        pdf=pdf/aint;
    case 'parconst'
        ii0=find(x<par);
        ii1=find(x>=par);
        pdf(ii1)=x(ii1).^(-pow1);
        pdf(ii0)=pdf(ii1(1));
        aint=par.^(-pow)/pow+par*par.^-pow1
        pdf=pdf/aint;
    case 'parr1'
        pdf=1./(1+(x./par).^pow1);
        aint=pi/(sin(pi/pow1)*pow1/par);
        pdf=pdf/aint;
    case 'parr2'
        pdf=1./(1+x./par).^pow1;
        aint=par/pow;
        pdf=pdf/aint;
end

if norm > 0
    s=sum(pdf(1:length(pdf)-1).*diff(x)');
    pdf=pdf/s;
end
pdf=gd(pdf);
pdf=edit_gd(pdf,'ini',x(1),'dx',x(2)-x(1),'x',x,'capt',['power law distribution k=' num2str(pow) ' type ' typ]);
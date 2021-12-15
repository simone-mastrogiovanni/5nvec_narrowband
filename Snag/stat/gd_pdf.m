function pdf=gd_pdf(typ,par,range)
%GD_PDF probability density functions
%
%           pdf=gd_pdf(typ,par,range)
%
%   typ    'gauss','exp','unif','chisq'
%   par    gauss->[mean,sig], exp->mean, unif->[min,max], chisq->dof
%   range  [min,max,dx]

% Version 2.0 - June 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

x=range(1):range(3):range(2);

switch typ
    case 'gauss'
        pdf=exp(-((x-par(1)).^2)/(2*par(2)))/sqrt(2*pi*par(2));
        capt='Gaussian distribution';
    case 'exp'
        pdf=exp(-x/par)/par;
        i=find(x<0);
        pdf(i)=0;
        i=find(x==0);
        pdf(i)=pdf(i)/2;
        capt='Exponential distribution';
    case 'unif'
        pdf=x*0;
        i=find(x>=par(1)&x<par(2));
        pdf(i)=1/(par(2)-par(1));
        capt='Uniform distribution';
    case 'chisq'
        pdf=x*0;
        i=find(x>=0);
        pdf(i)=x(i).^((par-2)/2).*exp(-x(i)/2)/(gamma(par/2)*2^(par/2));
        capt='Chi square distribution';
end

pdf=gd(pdf);
pdf=edit_gd(pdf,'dx',range(3),'ini',range(1),'capt',capt);
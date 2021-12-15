function err=plot_fit(x,y,covar,F,unc,res,errmag)
% PLOT_FIT plot of fit with uncertainty
%
%      err=plot_fit(x,y,covar,F,res)
%
%   x        abscissa value (length n)
%   y        ordinate value (length n)
%   covar    covariance matrix
%   F        base functions [n,M] 
%   unc      imposed uncertainty
%   res      residuals
%   errmag   error magnification

% Version 2.0 - July 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[n,M]=size(F);
err=x*0;
if ~exist('errmag','var')
    errmag=1;
end

for i = 1:n
    f=F(i,:);
    err(i)=f*covar*f';
end

err=sqrt(err);

fit=y+res;std(res)
err=err*std(res)/mean(unc);
figure,plot(x,err),grid on
figure,plot(x,y+res+err*errmag,'g'),hold on, grid on
plot(x,y+res-err*errmag,'g')
for i = 1:n
    plot([x(i) x(i)],[y(i)+res(i)+err(i)*errmag y(i)+res(i)-err(i)*errmag],'g')
end
plot(x,y+res),plot(x,y,'r.')
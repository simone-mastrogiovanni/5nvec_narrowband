function polyfit_res_plot(x,y,a,res,deg,nonew)
% POLYFIT_RES_PLOT in use with gen_lin_fit for polynomial fitting
%
%   polyfit_res_plot(x,y,a,res)
%
%  x,y     experimental data
%  a       polynomial coefficients
%  res     residuals
%  nonew   if exists use old figure

if ~exist('deg','var')
    deg=0;
end
xmin=min(x);
xmax=max(x);
xx=xmin:(xmax-xmin)/1000:xmax;

if exist('nonew','var')
    hold off
else
    figure
end
subplot(2,1,1),plot(x,y,'.'),grid on,hold on
plot(xx,polyval(a,xx),'r'),
if deg > 0
    title(sprintf('Data and fit of order %d',deg)) 
else
    title('Data and fit')
end
subplot(2,1,2),plot(x,res,'.'),grid on,hold on,plot(x,res,'r'),title('Residuals')


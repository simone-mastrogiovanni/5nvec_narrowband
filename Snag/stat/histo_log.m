function [xlog,x,h]=histo_log(in,N)
% histogram on log data
%
%    [xlog,x,h]=histo_log(in,N)
%
%  in   input data
%  N    number of bins
%

in=abs(in);
ii=find(in>0);
IN=log10(in(ii));

% inmax=max(IN);
[h,xlog]=hist(IN,N);

x=10.^xlog;

figure;loglog(x,h);title('amplitude histogram'),xlabel('amplitude'),grid on

figure;loglog(x,h.^2.*x,'r.');title('Power'),xlabel('amplitude'),grid on
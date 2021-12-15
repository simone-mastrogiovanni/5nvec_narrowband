function ul=upper_limit(ndf,mv,thr,dprob)
% UPPER_LIMIT  computes the upper limit as the signal value that gives the
%              observed value or more with the probability dprob
%
%   ul=upper_limit(ndf,mv,thr,dprob)
%
%    ndf    number of degrees of freedom (typically 2)
%    mv     noise mean value
%    thr    threshold 
%    dprob  detection probability

% Version 2.0 - May 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

conv=mv/ndf;
thr1=thr/conv;
p=1-dprob;

delta=0:0.01:20;

x=ncx2inv(p,ndf,delta);
i=find(x>thr1);
del0=delta(i(1));
delta=delta*conv;
x=x*conv;
ul=delta(i(1))
figure,plot(delta,x),hold on,grid on,plot(delta,delta*0+thr,'r')

x=0:0.01:30;
f=ncx2pdf(x,ndf,del0);
fa=1-chi2cdf(x,ndf);
x=x*conv;
f=f/conv;
fma=max(f);
figure,plot(x,f),hold on,grid on,plot([thr thr],[0 fma],'r')

figure,semilogy(x,fa),hold on,grid on,semilogy([thr thr],[min(fa) 1],'r')
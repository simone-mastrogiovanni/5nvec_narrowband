function m=robstat(x,p)
% robust statistics
%
%  x   data
%  p   prob (single value or array)
%  m   [median median(abs(x-median)) amp at perc amp at antiperc]
%
%   example: m=robstat(rand(1,1000),0.2)

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

m(1)=median(x);
m(2)=median(abs(x-m(1)))/0.6745; % norm to 1 sigma for normal data

n=length(p);
for i = 1:n
    k=2*i+1;
    m(k)=prctile(x,p(i)*100);
    m(k+1)=prctile(x,(1-p(i))*100);
end